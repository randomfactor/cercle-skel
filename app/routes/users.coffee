usersRoute = Ember.Route.extend {
  model: (params) ->
    this.get('store').find('user')
}

`export default usersRoute`