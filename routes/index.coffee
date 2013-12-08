
###
 * GET home page.
###

user_router = require './user'


exports.map_routes = (app) ->

  app.get '/users', user_router.index
  app.post '/users', user_router.create
  app.get '/users/:id', user_router.find
  app.put '/users/:id', authorize_owner_or_admin, user_router.modify

  app.get '/quarks', (req, res) ->
    res.json {
      quarks: [
        {
          id: 1
          name: 'Up'
        }
        {
          id: 2
          name: 'Down'
        }
      ]
    }

exports.index = (req, res) ->
  res.render 'index', { title: 'Fields to Fork' }

# only allow same user or admin to modify a user after it is created
authorize_owner_or_admin = (req, res, next) ->
  if req.user?._id is req.params?.id
    next()
  else if 'admin' in req.user?.roles
    next()
  else
    res.status(401).send('Not authorized.')

exports.User = user_router
