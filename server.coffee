
###
  Module dependencies.
###

express = require('express')
routes = require('./routes')
http = require('http')
path = require('path')
sessStore = require('connect-redis')(express)

# storage documents
db = require './lib/dbdata'
User = require('./lib/user').User

# login will use browserid
passport = require 'passport'
BrowserIDStrategy = require('passport-browserid').Strategy

app = express()

redis_config = {}
couchdb_url = ''
primary_url = ''

app.configure 'development', ->
  primary_url = 'http://lvh.me:3000'
  redis_config = { secret: "cercle-stack", store: new sessStore { db: 2 } }
  couchdb_url = 'http://localhost:5984/cercle'

app.configure 'production', ->
  primary_url = 'http://fieldstofork.jit.su'
  redis_config = { secret: "cercle-stack", store: new sessStore { db: 2 }, url: 'TBD' }
  couchdb_url = 'TBD'


# all environments
app.configure ->
  app.set('port', process.env.PORT || 3000)
  app.set('views', path.join(__dirname, 'views'))
  app.set('view engine', 'jade')
  app.set('couchurl', couchdb_url)    # save the persistent storage URL for later initialization
  app.use(express.favicon())
  app.use(express.logger('dev'))
  app.use(express.bodyParser())
  app.use(express.json())
  app.use(express.urlencoded())
  app.use(express.methodOverride())
  app.use(express.cookieParser('your secret here'))
  app.use(express.session(redis_config))
  app.use passport.initialize()
  app.use passport.session()
  app.use(app.router)
  app.use(require('stylus').middleware(path.join(__dirname, 'public')))
  app.use('/vendor', express.static(path.join(__dirname, 'vendor')))
  app.use('/assets', express.static(path.join(__dirname, 'tmp/result/assets')))
  app.use(express.static(path.join(__dirname, 'public')))

# development only
app.configure 'development', ->
  app.use(express.errorHandler())
  app.set('view options', { pretty: true })
  app.locals.pretty = true
  app.use('/tests', express.static(path.join(__dirname, 'tests')))
  app.use('/test2', express.static(path.join(__dirname, 'tmp/result/tests')))

#
app.configure ->
  passport.serializeUser (user, done) ->
    done null, user._id

  passport.deserializeUser (email, done) ->
    User.find_by_id(email).then(
      (user) ->
        done null, user
      (err) ->
        done err
    )

  passport.use new BrowserIDStrategy {
    audience: primary_url
  },
  (email, done) ->
    User.find_or_create_by_email(email).then(
      (user) ->
        done null, user
      (err) ->
        console.log 'lookup by email failed'
        done err
    )

# define routes for login with browserid and logout
app.configure ->
  app.get('/', routes.index)
  app.get '/logout', (req, res) ->
    req.logout()
    res.json { user: req.user }
  app.post '/auth/browserid',
    passport.authenticate 'browserid', { failureRedirect: '/logout' }
    (req, res) ->
      res.json { user: req.user }
  routes.map_routes app

# initialize the URL for persistent json document storage
db.setup { db_url: app.get 'couchurl' }

http.createServer(app).listen(app.get('port'), ->
  console.log('Express server listening on port ' + app.get('port'))
)
