# basic methods to load and store documents to couchdb

couchdb = require 'then-couchdb'
uuid = require './math-uuid'

dbconfig = null
exports.setup = (config) ->
  dbconfig = config

class DbData
  @conn: ->
    couchdb.createClient dbconfig.db_url

  @save: (doctype, doc) ->
    doc._id = Math.uuid() unless doc._id?
    doc.type = doctype if doctype? and not doc.type
    # console.log 'saving ...'
    # console.dir doc
    @conn().save doc

  @find_by_id: (doctype, key) ->
    @conn().get(key).then(
      (doc) ->
        throw new Error('Not found') unless doc?.type is doctype
        doc
    )

  @find_all: (vname, query) ->
    q = { limit: 200, include_docs: true }
    if typeof query is 'object'
      q[key] = val for key, val of query
    @conn().view(vname, q).then(
      (data) ->
        d.doc for d in data.rows
    )

exports.DbData = DbData
