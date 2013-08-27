request = require "request"

# Either NODE ENV or constructor options
# WEASEL_HTTP_PROXY
# WEASEL_URL
# WEASEL_PROJECT_ID
# WEASEL_PROJECT_API_KEY

send = (data, opts) ->
  options = {}
  options.url = opts.url or WEASEL_URL or defaultOptions.url
  options.url += '/log'
  options.proxy = opts.proxy or WEASEL_HTTP_PROXY
  options.json = true
  options.body =
    id: opts.projectId or WEASEL_PROJECT_ID
    key: opts.projectKey or WEASEL_PROJECT_API_KEY
  
  request.post(
    options,
    (error, response, body) ->
      console.log error
  )
