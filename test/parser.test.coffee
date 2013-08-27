Require = require('covershot').require.bind(null, require)

chai = require "chai"
expect = chai.expect
assert = chai.assert

path = require "path"

Require "../index"
parser = Require "../lib/parser"

describe('parse Node error', () ->
  it('should parse type', (done) ->
    error = new Error "The error message"
    parser.parseError(error, (err, parsedError) ->
      assert.equal(parsedError.type, "Error")
      done()
    )
  )
  it('should parse message', (done) ->
    error = new Error "The error message"
    parser.parseError(error, (err, parsedError) ->
      assert.equal(parsedError.message, "The error message")
      done()
    )
  )
  it('should parse stacktrace', (done) ->
    error = new Error "The error message"
    parser.parseError(error, (err, parsedError) ->
      assert.equal(parsedError.stack[0].uri, __filename)
      done()
    )
  )
)
