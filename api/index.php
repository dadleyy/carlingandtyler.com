<?php

require __DIR__ . '/../vendor/autoload.php';

use \Slim\Slim as Application;
use GuzzleHttp\Client;
use GuzzleHttp\Exception\ClientException;

Dotenv::load(__DIR__ . '/../');

$app = new Application();

function getAuthHeader() {
  $twitter_consumer = $_ENV['TWITTER_CONSUMER'];
  $twitter_secret = $_ENV['TWITTER_SECRET'];
  $concatenated_auth = $twitter_consumer . ':' . $twitter_secret;
  $encoded_app_auth = base64_encode($concatenated_auth);
  return "Basic " . $encoded_app_auth;
}

$app->get('/tweets/:query', function ($query) { 
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