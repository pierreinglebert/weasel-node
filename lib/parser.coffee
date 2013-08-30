util = require "util"

parseStack = (frames, cb) ->
  parsedStack = []
  for frame in frames
    parsedFrame = {}

    #Uri
    parsedFrame.uri = ""
    if frame.isNative()
      parsedFrame.uri = "native"
    else if frame.isEval()
      parsedFrame.uri = "eval at " + frame.getEvalOrigin()
    else
      parsedFrame.uri = frame.getFileName()

    #line
    parsedFrame.line = frame.getLineNumber()

    #uri
    parsedFrame.column = frame.getColumnNumber()

    #function name
    functionName = frame.getFunction().name
    isConstructor = frame.isConstructor()
    isMethodCall = not (frame.isToplevel() or isConstructor)
    if isMethodCall
      methodName = frame.getMethodName()
      if methodName?
        funtionName = methodName
      functionName = frame.getTypeName() + "." + (funtionName or "<anonymous>")
    else if isConstructor
      functionName = "new " + (functionName or "<anonymous>")
    parsedFrame.func = functionName

    parsedStack.push parsedFrame

  cb(null, parsedStack)


module.exports.parseError = (error, cb) ->
  #stack is loaded lazily
  error.stack
  parsedError = {}
  parsedError.type = error.name
  parsedError.message = error.message

  parseStack(error.structuredStackTrace, (err, stack) ->
    parsedError.stack = stack

    err = JSON.parse util.inspect(err)
    
    cb(err, parsedError)
  )
