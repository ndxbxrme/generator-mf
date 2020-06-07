import './index.styl'
import {Auth, API} from 'aws-amplify'
require './configure-amplify.coffee'
mobile = require 'is-mobile'

cleanup = []
document.body.className += if mobile() then ' mobile' else 'web'
page = document.querySelector '.page'
app = window.app =
  baseURI: document.baseURI.replace(window.location.origin, '')
  useHash: /\.html/.test document.baseURI
  loggedIn: false
  setState: ->
    document.body.className = document.body.className.replace(/ *loaded/g, '') + ' loading'
    await fn() for fn in cleanup
    cleanup = []
    [@route, ...@params] = (if @useHash then window.location.hash.replace('#', '').replace(/^\//, '') else window.location.pathname.replace(@baseURI, '')).split /\//g
    @route = @route or 'dashboard'
    [@route, @params] = @permissions.check @route, @params, app.user
    template = @templates[@route] or @templates.dashboard
    controller = @controllers[@route] or @controllers.dashboard
    page.innerHTML = template app: @, ctrl: controller? @params
    await controller.onload?()
    document.body.className = document.body.className.replace(/ *loading/g, '') + ' loaded'
  goto: (route) ->
    if @useHash
      document.location.hash = route
    else
      route = document.baseURI.replace(document.location.origin, '') + route.replace(/^\//, '')
      window.history.pushState route, null, route if route isnt window.location.pathname
    @setState()
  onCleanup: (fn) ->
    cleanup.push fn
  storage: require './components/storage/storage.coffee'
  permissions: require './components/permissions/permissions.coffee'
require('./components.coffee') app
window.addEventListener 'popstate', -> app.setState()
main = ->
  try
    <%= settings.cognitoUserPoolId?'':'#' %>app.loggedIn = true if app.user = await Auth.currentAuthenticatedUser()
  app.setState()
main()
