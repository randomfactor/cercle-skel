db = require './dbdata'

# _id: (uuid)
# email: "any@example.com"
# name: "supergrrrl"
# bio: "I was born a poor black child."
# photo: (attach).png -or- http://

class User extends db.DbData
  @save: (doc) ->
    super 'User', doc

  @find_by_id: (key) ->
    super 'User', key

  @find_all: (query) ->
    super 'app/userByName', query

  @find_by_email: (email) ->
    @conn().view('app/userByEmail', {key: email, include_docs: true}).then(
      (data) ->
        if data.rows?.length > 0
          data.rows[0].doc
        else
          throw new Error "#{email} not found"
    )

  @find_or_create_by_email: (email) ->
    @find_by_email(email).then(
      (user) =>
        user
      (err) =>
        # create the new user with defaults
        user = { email: email, name: "Your Name", roles:["user"] }
        @save(user)
    )

exports.User = User
