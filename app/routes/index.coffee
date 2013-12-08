indexRoute = Ember.Route.extend
  model: ->
    @store.find('quark')

`export default indexRoute`
