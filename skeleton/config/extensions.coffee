module.exports =

  passport:
    enabled:  yes
    model:    'User'
    provider: ['amazon', 'google', 'facebook']
    
    facebook:
      scope: ['email', 'user_birthday']
    google:
      scope: [
        'https://www.googleapis.com/auth/userinfo.profile',
        'https://www.googleapis.com/auth/userinfo.email'
      ]
    amazon:
      scope: ['profile']