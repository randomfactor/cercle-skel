underAdapter = DS.RESTAdapter.extend {
  serializer: DS.RESTSerializer.extend {
    primaryKey: (type) ->
      return '_id'
  }
}

`export default underAdapter`
