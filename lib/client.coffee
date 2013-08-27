request = require "request"

# Either NODE ENV or constructor options
# WEASEL_HTTP_PROXY
# WEASEL_URL
# WEASEL_PROJECT_ID
# WEASEL_PROJECT_API_KEY

module.exports.send = (data, opts, cb) ->
  options = {}
  options.url = opts.url or process.env.WEASEL_URL or "http://www.weaseljs.com"
  options.url += '/log'
  options.proxy = opts.proxy or process.env.WEASEL_HTTP_PROXY
  options.json = true
  options.form =
    projectId: opts.projectId or process.env.WEASEL_PROJECT_ID
    projectKey: opts.projectKey or process.env.WEASEL_PROJECT_API_KEY
  
  request.post(
    options,
    (error, response, body) ->
      #console.log error
      if error
        cb(error, "HTTP error")
      if response.statusCode is 200
        cb(null, body)
      else
        cb(new Error("Error"), body)
  )
