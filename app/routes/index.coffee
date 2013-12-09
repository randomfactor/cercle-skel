indexRoute = Ember.Route.extend {
  model: ->
    return this.get('store').find('user')
}

`export default indexRoute`