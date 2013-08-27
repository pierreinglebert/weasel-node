Require = require('covershot').require.bind(null, require)

nock = require "nock"
chai = require "chai"
expect = chai.expect
assert = chai.assert

client = Require "../lib/client"

describe('parse Node error', () ->
  it('should emit an error if id or key is not defined or wrong', (done) ->
    stack = {projectId: '', projectKey: '5454d687687654654'}
    scope = nock('http://www.weaseljs.com')
      .post('/log', stack)
      .reply(409, "Erreur")
    client.send {}, stack, (err) ->
      assert.isNotNull err
      done()
  )
  
  it('should not emit an error if response is correct', (done) ->
    scope = nock('http://www.weaseljs.com')
      .post('/log')
      .reply(200, {})
    stack = {projectId: '', projectKey: '5454d687687654654'}
    client.send {}, stack, (err) ->
      done()
  )
)