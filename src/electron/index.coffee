yeoman = require 'yeoman-generator'
utils = require '../utils'

module.exports = yeoman.generators.Base.extend
  checkForConfig: ->
    cb = @async()
    if not @filters = @config.get 'filters'
      @log 'Cannot find the config file'
      return
    cb()
  write: ->
    utils.write this, @filters
