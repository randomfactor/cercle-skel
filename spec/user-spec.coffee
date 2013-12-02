db = require('../lib/dbdata')
db.setup { db_url: 'http://localhost:5984/cercle' }
user = require('../lib/user')
User = user.User

describe 'User', ->
  it "gets the list of all users", (test_done) ->
    p = User.find_all()
    p.then(
      (data) ->
        expect(data.length).toBeGreaterThan(0)
        test_done()
      (err) ->
        expect(err).toBeNull()
        test_done()
    )
  it "creates an admin (if not there already)", (test_done) ->
    console.log 'Looking for randumfaktor'
    User.find_by_id('randumfaktor@hotmail.com').then(
      (user) ->
        if user?
          expect(user.name).toBe 'Randall Krebs'
          test_done()
        else
          expect(user).toBeNull()
          test_done()
      (err) ->
        console.log err?.message + ': creating admin user'
        adm = {_id: 'randumfaktor@hotmail.com', name: "Randall Krebs", roles: [ 'admin', 'user' ], bio: "", photo: ""}
        User.save(adm).then(
          (user) ->
            console.dir user
            expect(user._rev).not.toBeNull()
            test_done()
          (err) ->
            expect(err).toBeNull()
            test_done()
        )
    )
