db_utils = require '../../support/db_utils'

UserSchema = require './UserSchema'

auth_routes = require './auth_routes'

dbs = {}
auth_module = {}

auth_module.open_db = (site,cb) ->
  dbs.auth = db_utils.open_db "mongodb://localhost/#{site}_auth", 
    'User' : UserSchema
    , (db_context) ->
      console.log "Database opened...[#{db_context.conn.name}]"
      cb()

auth_module.init = (site, app, route_root, cb) ->
  auth_module.open_db site,() ->
      # Load the auth_filters
      #
      auth_module.auth_filters = require('./auth_filters')(dbs.auth)

      # Load the routes
      #
      require('./auth_routes')(app,dbs,auth_module.auth_filters,route_root)    

      console.log "Routes loaded ... [#{route_root}]"

      cb()

module.exports = auth_module

