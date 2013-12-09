userRoute = Ember.Route.extend {
  model: (params) ->
    this.get('store').find('user', params.user_id)
}

`export default userRoute`