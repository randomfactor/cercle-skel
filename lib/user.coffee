db = require './dbdata'

class User extends db.DbData
  @save: (doc) ->
    super 'User', doc

  @find_by_id: (key) ->
    super 'User', key

  @find_all: (query) ->
    super 'app/userByName', query

  @find_or_create_by_email: (email) ->
    @find_by_id(email).then(
      (user) =>
        user
      (err) =>
        # create the new user with defaults
        user = { _id: email, name: "Your Name", roles:["user"], bio: "", photo: "" }
        @save(user).then(
          (data) =>
            @find_by_id(email)
        ).then(
          (data) =>
            console.log "created new user: #{email}"
            data
        )
    )

exports.User = User
