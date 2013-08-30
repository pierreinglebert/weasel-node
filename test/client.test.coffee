Require = require('covershot').require.bind(null, require)

nock = require "nock"
chai = require "chai"
expect = chai.expect
assert = chai.assert

client = Require "../lib/client"

describe('client send', () ->
  it('should emit an error if id or key is not defined or wrong', (done) ->
    options = {projectId: '', projectKey: '5454d687687654654'}
    scope = nock('http://www.weaseljs.com')
      .post('/log')
      .reply(409, "Erreur")
    client.send {}, options, (err) ->
      assert.isNotNull err
      done()
  )
  
  it('should not emit an error if response status is correct', (done) ->
    scope = nock('http://www.weaseljs.com')
      .post('/log')
      .reply(200, {})
    options = {projectId: '', projectKey: '5454d687687654654'}
    client.send {}, options, (err) ->
      done()
  )

  it('should send right data', (done) ->
    scope = nock('http://www.weaseljs.com')
      .post('/log')
      .reply(200, (uri, requestBody) ->
        return requestBody
      )
    options = {projectId: '', projectKey: '5454d687687654654'}
    stack =
      type: "Error"
      stack: [
        line: 22
        name: "xxx"
      ,
        line: 55
        name: "ot"
      ]
    client.send stack, options, (err, body) ->
      assert.equal body.type, "Error"
      assert.equal body.stack[0].line, 22
      assert.equal body.stack[1].name, "ot"
      done()
  )

)