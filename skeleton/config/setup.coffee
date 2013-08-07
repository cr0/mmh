module.exports = 

  server:
    host: 'localhost'
    port: 3000
    path: '' # trailing /

  session:
    enabled: true
    secret: '1234567890abcdef'

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