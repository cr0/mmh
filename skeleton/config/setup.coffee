module.exports = 

  server:
    host: 'localhost'
    port: 3000
    path: '' # trailing /

  session:
    enabled: true
    secret: '1234567890abcdef'

  mongo:
    host:     '127.0.0.1'
    port:     27017
    database: 'test'

  auth:
    google:
      id:     ''
      secret: ''
    facebook:
      id:     ''
      secret: ''
    amazon:
      id:     ''
      secret: ''

  view:
    engine: 'jade'