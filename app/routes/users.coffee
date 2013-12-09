usersRoute = Ember.Route.extend {
  model: (params) ->
    return this.get('store').find('user', params.user_id)
}

`export default usersRoute`