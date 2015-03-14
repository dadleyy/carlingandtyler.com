'use strict';

exports.up = function(knex, Promise) {
  return knex.schema.createTable('rsvp', function (table) {
    table.increments();
    table.string('email');
    table.boolean('attending');
    table.dateTime('createdAt');
    table.dateTime('updatedAt');
  });
};

exports.down = function(knex, Promise) {
  return knex.schema.dropTable('rsvp');
};
