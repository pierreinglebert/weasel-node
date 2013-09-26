Require = require('covershot').require.bind(null, require)

chai = require "chai"
expect = chai.expect
assert = chai.assert

path = require "path"

Require "../index"
errorHandler = Require "../index"

###
describe('parse Node error', () ->
  it('should parse type', (done) ->
    errorHandler.registerGlobalHandler((error, result) ->
      scope = nock('http://www.weaseljs.com')
      .post('/log')
      .reply(200, {})

      parser.parseError(error, (error, parsedError) ->
        client.send {}, parsedError, (err) ->
          done()
      )
    )
  )
)
###
