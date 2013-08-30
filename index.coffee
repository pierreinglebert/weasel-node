util = require "util"
parser = require "./lib/parser"

module.exports.registerGlobalHandler = (cb) ->
  process.on "uncaughtException", (error) ->
    parser.parseError error, (err, parsedError) ->
      unless err?
        client.send parsedError, (error, result) ->
          if cb?
            cb(error, result)

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