{API} = require 'aws-amplify'
apiName = "<%= settings.apiName %>"
getDatabase = ->
  str = localStorage.getItem('database') or '{}'
  JSON.parse str
saveDatabase = (database) ->
  localStorage.setItem 'database', JSON.stringify database
module.exports =
  list: (route) ->
    try
      {body} = await API.get apiName, route
      app.offline = false
      return JSON.parse body
    catch e
      if e.message is 'Network Error'
        app.offline = true
      return []
  single: (route) ->
    try
      JSON.parse (await API.get apiName, route).body
    catch e
      return null
  post: (route, body) ->
    try
      return await API.post apiName, route, body:body
    catch e
      console.log e
    null
  delete: (route) ->
    try
      return await API.del apiName, route
    catch e
      console.log e
    null
