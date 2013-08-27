require "request"

# Either NODE ENV or constructor options
# WEASEL_HTTP_PROXY
# WEASEL_URL
# WEASEL_PROJECT_ID
# WEASEL_PROJECT_API_KEY

request.post(
  url: 'http://www.weaseljs.com/log'
  json: true
  proxy: ''
  body:
    id: 'rte'
    key:'value'
  , 
  (error, response, body) ->
    console.log error
)

log = (type, error) ->
  if not error? and typeof type == "object"
    error = type
    type = "error"

  client.send

module.exports.registerGlobalHandler = (cb) ->
  process.on "uncaughtException", (err) ->
    if cb
      client.once "success", ->
        cb null, err

      client.once "error", (reqErr) ->
        cb reqErr, err

    client.captureError err, (result) ->
      node_util.log "uncaughtException: " + client.getIdent(result)
