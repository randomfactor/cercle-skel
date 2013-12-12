couchapp = require('couchapp')
path = require('path');

ddoc = {
  _id: '_design/app'
  views:
    allByType:
      map: (doc) ->
        if doc.type? then emit doc.type, 1 else emit null, 1
    userByName:
      map: (doc) ->
        emit doc.name, 1 if doc.type is "User"
    userByEmail:
      map: (doc) ->
        emit doc.email, 1 if doc.type is "User" and doc.email?
  lists: {}
  shows: {}
}

module.exports = ddoc

couchapp.loadAttachments ddoc, path.join(__dirname, 'attachments')
