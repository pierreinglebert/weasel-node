Require = require('covershot').require.bind(null, require)

chai = require "chai"
expect = chai.expect
assert = chai.assert

nock = require "nock"

request = Require "request";

describe('parse Node error', () ->
  it('should emit an error if id is not defined or wrong', (done) ->

    stack = 
      id: ''
      apiKey: '5454d687687654654'

    scope = nock('http://www.weaseljs.com')
      .post('/log', stack)
      .reply(409, "Erreur");
      #.reply(200, function(uri, requestBody) {
      #  return requestBody;
      #});
    
    request
      method: "POST"
      uri: "http://www.weaseljs.com/log"
      form: stack,
      (error, response, body) ->
        assert.equal response.statusCode, 409
        done()
  )
  it('should emit an error if api key is not defined or wrong', (done) ->
    scope = nock('http://www.weaseljs.com')
      .get('/')
      .reply(200, {username: 'pgte', email: 'pedro.teixeira@gmail.com', _id: "4324243fsd"})

    done()
  )
)