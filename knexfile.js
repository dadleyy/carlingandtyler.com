var dotenv = require('dotenv');

module.exports = (function() {

  var config = {};

  dotenv.load();

  config.production = config.development = {
    client: 'mysql',
    connection: {
      host: process.env['MYSQL_HOST'],
      user: process.env['MYSQL_USERNAME'],
      password: process.env['MYSQL_PASSWORD'],
      database: process.env['MYSQL_DATABASE']
    },
    migrations: {
      tableName: 'migrations'
    }
  };

  return config;

})();
