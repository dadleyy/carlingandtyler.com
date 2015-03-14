<?php

require __DIR__ . '/../vendor/autoload.php';

use \Slim\Slim as Application;
use \GuzzleHttp\Client;
use \GuzzleHttp\Exception\ClientException;

function loadEnv() {
  $env_path = __DIR__ . '/../.env';
  date_default_timezone_set("America/New_York");
  $lines = file($env_path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
  foreach($lines as $line) {
    if(strpos($line, '=') !== false) {
      list($name, $value) = array_map('trim', explode('=', $line, 2));
      $_ENV[$name] = $value;
    }
  }
}

$app = new Application();

function getAuthHeader() {
  $twitter_consumer = $_ENV['TWITTER_CONSUMER'];
  $twitter_secret = $_ENV['TWITTER_SECRET'];
  $concatenated_auth = $twitter_consumer . ':' . $twitter_secret;
  $encoded_app_auth = base64_encode($concatenated_auth);
  return "Basic " . $encoded_app_auth;
}

function getConnection() {
  $mysql_host_string = 'host='.$_ENV['MYSQL_HOST'];
  $mysql_db_string = 'dbname='.$_ENV['MYSQL_DATABASE'];
  $mysql_connection_string = 'mysql:'.$mysql_host_string.';'.$mysql_db_string;
  $mysql_username = $_ENV['MYSQL_USERNAME'];
  $mysql_password = $_ENV['MYSQL_PASSWORD'];
  $mysql_connection_params = array(PDO::ATTR_PERSISTENT => false);
  $mysql_connection = new PDO($mysql_connection_string, $mysql_username, $mysql_password, $mysql_connection_params);
  $mysql_connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  return $mysql_connection;
}

$app->delete('/rsvp/:id', function($id) use ($app) {
  loadEnv();
  $app->response->headers->set('Content-Type', 'application/json');

  try {
    $mysql_connection = getConnection();
    $stmt = $mysql_connection->prepare("DELETE FROM rsvp WHERE id = :id");
    $stmt->bindParam('id', $id);
    $stmt->execute();
  } catch(Exception $e) {
    $app->response->setStatus(422);
    $response_body = json_encode(array("error" => "failed get", "info" => $e));
    $app->response->setBody($response_body);
    return;
  }

  $response_body = json_encode(array(
    "status" => "ok"
  ));

  $app->response->setStatus(200);
  $app->response->setBody($response_body);
});

$app->get('/rsvp', function() use($app) {
  loadEnv();
  $app->response->headers->set('Content-Type', 'application/json');

  $results = NULL;
  try {
    $mysql_connection = getConnection();
    $stmt = $mysql_connection->prepare("SELECT id, email, attending, createdAt from rsvp");
    $stmt->execute();
    $results = $stmt->fetchAll();
  } catch(Exception $e) {
    $app->response->setStatus(422);
    $response_body = json_encode(array("error" => "failed get", "info" => $e));
    $app->response->setBody($response_body);
    return;
  }

  $cleaned = array();
  foreach($results as $result) {
    $cleaned[] = array(
      "created_at" => $result['createdAt'],
      "attending" => $result['attending'],
      "id" => $result['id']
    );
  }

  $app->response->setStatus(200);
  $app->response->setBody(json_encode($cleaned));
});

$app->post('/rsvp', function() use($app) {
  loadEnv();
  $app->response->headers->set('Content-Type', 'application/json');

  $email = $app->request->post('email');
  $attending = $app->request->post('attending');
  $body = $app->request->getBody();

  if(!$email) {
    $decoded = json_decode($body, true);
    $email = $decoded['email'];
    $attending = $decoded['attending'];
  }

  $is_valid = filter_var($email, FILTER_VALIDATE_EMAIL);
  if(!$is_valid) {
    $app->response->setStatus(422);
    $response_body = json_encode(array("error" => 'invalid email', "email" => $email));
    $app->response->setBody($response_body);
    return;
  }

  $result = NULL;
  $mysql_connection = NULL;

  try {
    $mysql_connection = getConnection();
    $stmt = $mysql_connection->prepare("INSERT INTO rsvp (attending, email, createdAt) VALUES (:attending, :email, NOW())");
    $stmt->bindParam('email', $email);
    $is_attending = intval($attending);
    $stmt->bindParam('attending', $is_attending);
    $stmt->execute();
  } catch(Exception $e) {
    $app->response->setStatus(422);
    $response_body = json_encode(array("error" => "failed saving", "info" => $e));
    $app->response->setBody($response_body);
    return;
  }

  $created_id = $mysql_connection->lastInsertId();
  $response_body = json_encode(array(
    "email" => $email,
    "id" => $created_id
  ));

  $app->response->setStatus(200);
  $app->response->setBody($response_body);
});

$app->get('/tweets/:query', function ($query) use($app) {
  loadEnv();
  $app->response->headers->set('Content-Type', 'application/json');

  $client = new Client();
  $auth_header = getAuthHeader();
  $api_home = "https://api.twitter.com";

  $auth_config = [
    'headers' => [
      'Authorization' => $auth_header,
      'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8'
    ],
    'body' => 'grant_type=client_credentials'
  ];

  $response = false;
  try {
    $response = $client->post($api_home . '/oauth2/token', $auth_config);
  } catch(ClientException $e) {
    $response = false;
  }

  if(!$response) {
    echo json_encode(['error' => 'unable to get auth token from twitter']);
    return;
  }

  $bearer_token = false;
  try {
    $body = $response->getBody();
    $parsed = json_decode($body, true);
    $bearer_token = $parsed['access_token'];
  } catch(Exception $e) { 
    $bearer_token = false;
  }

  if(!$bearer_token) {
    echo json_encode(['error' => 'unable to parse return data from twitter api']);
    return;
  }

  try {
    $cleaned_query = urlencode(base64_decode($query));
    $query_url = $api_home . '/1.1/search/tweets.json?q=' . $cleaned_query;
    $query_config = [
      'headers' => [
        'Authorization' => 'Bearer ' . $bearer_token
      ]
    ];
    $response = $client->get($query_url, $query_config);
  } catch(Exception $e) {
    echo json_encode(['error' => 'unable to search twitter api']);
    return;
  }

  $body = '';
  try {
    $body = $response->getBody();
    $parsed = json_decode($body, true);
  } catch(Exception $e) {
    echo json_encode(['error' => 'unable to search twitter api']);
    return;
  }

  echo $body;

});

$app->run();

?>
