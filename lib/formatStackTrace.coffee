# Copyright 2006-2008 the V8 project authors. All rights reserved.
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of Google Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
FormatStackTrace = (error, frames) ->
  lines = []
  try
    lines.push error.toString()
  catch e
    try
      lines.push "<error: " + e + ">"
    catch ee
      lines.push "<error>"
  
  for frame in frames
    line = undefined
    try
      line = FormatSourcePosition(frame)
    catch e
      try
        line = "<error: " + e + ">"
      catch ee
        
        # Any code that reaches this point is seriously nasty!
        line = "<error>"
    lines.push "    at " + line
  lines.join "\n"

FormatSourcePosition = (frame) ->
  fileLocation = ""
  if frame.isNative()
    fileLocation = "native"
  else if frame.isEval()
    fileLocation = "eval at " + frame.getEvalOrigin()
  else
    fileName = frame.getFileName()
    if fileName
      fileLocation += fileName
      lineNumber = frame.getLineNumber()
      if lineNumber?
        fileLocation += ":" + lineNumber
        columnNumber = frame.getColumnNumber()
        fileLocation += ":" + columnNumber  if columnNumber
  fileLocation = "unknown source"  unless fileLocation
  line = ""
  functionName = frame.getFunction().name
  addPrefix = true
  isConstructor = frame.isConstructor()
  isMethodCall = not (frame.isToplevel() or isConstructor)
  if isMethodCall
    methodName = frame.getMethodName()
    line += frame.getTypeName() + "."
    if functionName
      line += functionName
      line += " [as " + methodName + "]"  if methodName and (methodName isnt functionName)
    else
      line += methodName or "<anonymous>"
  else if isConstructor
    line += "new " + (functionName or "<anonymous>")
  else if functionName
    line += functionName
  else
    line += fileLocation
    addPrefix = false
  line += " (" + fileLocation + ")"  if addPrefix
  line
module.exports = FormatStackTrace