`import Resolver from 'resolver'`
# `import User from 'appkit/models/user'`
#`import ApplicationAdapter from 'appkit/adapters/application'`

App = Ember.Application.extend {
  LOG_ACTIVE_GENERATION: true
  LOG_MODULE_RESOLVER: true
  LOG_TRANSITIONS: true
  LOG_TRANSITIONS_INTERNAL: true
  LOG_VIEW_LOOKUPS: true
  modulePrefix: 'appkit' # TODO: loaded via config
  Resolver: Resolver['default']
}

Ember.RSVP.configure 'onerror', (error) ->
  # ensure unhandled promises raise awareness.
  # may result in false negatives, but visibility is more important
  if (error instanceof Error)
    Ember.Logger.assert(false, error)
    Ember.Logger.error(error.stack)

#App.ApplicationAdapter = ApplicationAdapter
# App.User = User

#App.store = DS.Store.extend {
#  adapter: App.ApplicationAdapter
#}

###
App.Store = DS.Store.extend {
  adapter: UnderAdapter
}

p = @get('store').find 'user', 'randumfaktor@hotmail.com'
p.then(
    (user) ->
      App.currentUser = user
    (err) ->
      console.dir err
)
###

`export default App`
