couchapp = require('couchapp')
path = require('path');

ddoc = {
  _id: '_design/app'
  views:
    userByName:
      map: (doc) ->
        emit doc.name, 1 if doc.type is "User"
  lists: {}
  shows: {}
}

module.exports = ddoc

couchapp.loadAttachments ddoc, path.join(__dirname, 'attachments')
