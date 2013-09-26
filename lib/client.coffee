request = require "request"

# Either NODE ENV or constructor options
# WEASEL_HTTP_PROXY
# WEASEL_URL
# WEASEL_PROJECT_ID
# WEASEL_PROJECT_API_KEY

module.exports.send = (data, opts, cb) ->

  unless cb?
    if typeof opts is "function"
      cb = opts
    else
      cb = ->

  options = {}
  options.url = opts.url or process.env.WEASEL_URL or "http://www.weaseljs.com"
  options.url += '/log'
  options.proxy = opts.proxy or process.env.WEASEL_HTTP_PROXY
  options.json = true
  options.body = data
  options.body.projectId = opts.projectId or process.env.WEASEL_PROJECT_ID
  options.body.projectKey = opts.projectKey or process.env.WEASEL_PROJECT_API_KEY
  
  request.post(
    options,
    (error, response, body) ->
      if error
        cb(error, "HTTP error")
      if response.statusCode is 200
        cb(null, body)
      else
        cb(new Error("Error"), body)
  )
