Router = Ember.Router.extend(); # ensure we don't share routes between all Router instances

Router.map ->
  this.route('component-test')
  this.route('helper-test')
  # this.resource('posts', ->
  #   this.route('new')
  #
  this.resource 'users'
  this.resource 'user', { path: '/user/:user_id' }


`export default Router`
