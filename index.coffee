util = require "util"
parser = require "./lib/parser"
client = require "./lib/client"

module.exports.sendError = (error, cb) ->
  parser.parseError error, (err, parsedError) ->
      unless err?
        client.send parsedError, (error, result) ->
          if cb?
            cb(error, result)

module.exports.registerGlobalHandler = (cb) ->
  process.on "uncaughtException", (error) ->
    module.exports.sendError error, cb

patchStackTrace = ->
  previous = Error.prepareStackTrace
  Error.prepareStackTrace = (error, structuredStackTrace) ->
    error.structuredStackTrace = structuredStackTrace
    if previous?
      previous.apply this, arguments
    else
      #v8 parse
      require("./lib/formatStackTrace")(error, structuredStackTrace)

patchStackTrace()