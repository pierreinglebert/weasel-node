

###


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
###

patchStackTrace = ->
  previous = Error.prepareStackTrace
  Error.prepareStackTrace = (error, structuredStackTrace) ->
    error.structuredStackTrace = structuredStackTrace
    if previous?
      previous.call this, arguments
    else
      #v8 parse
      require("./lib/formatStackTrace")(error, structuredStackTrace)

patchStackTrace()