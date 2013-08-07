require( 'coffee-script' );


module.exports = {

  Application: require( './app' ),
  Event: require('./util/Event'),

  Controller: require('./mvc/Controller'),
  RestController: require('./mvc/RestController'),

  Model: require('./mvc/Model'),

  Policy: require('./access/Policy')

};