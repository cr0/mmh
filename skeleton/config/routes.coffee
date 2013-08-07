module.exports = 

  '/':              'home#index'

  '/auth/req':      'auth#required'
  '/auth/failed':   'auth#failed'
  '/auth/logout':   'auth#logout'
  '/auth/:provider/callback': 'auth#validate'
