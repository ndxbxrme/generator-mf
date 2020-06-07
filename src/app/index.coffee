yeoman = require 'yeoman-generator'
utils = require '../utils.js'
fs = require 'fs'

module.exports = yeoman.generators.Base.extend
  init: ->
    @argument 'name',
      type: String
      required: true
  prompts: ->
    cb = @async()
    @prompt [
      {
        type: 'input'
        name: 'displayName'
        message: 'Display name'
        default: @name
      }
      {
        type: 'input'
        name: 'productPrefix'
        message: 'Product prefix, eg com.rainstormweb'
        default: 'com.rainstormweb'
      }
      {
        type: 'input'
        name: 's3bucket'
        message: 'S3 bucket for deployment'
        default: 's3://www.rainstormweb.com/' + @name
      }
      {
        type: 'input'
        name: 'apiName'
        message: 'API name'
      }
      {
        type: 'input'
        name: 'apiUrl'
        message: 'API url'
      }
      {
        type: 'input'
        name: 'cognitoRegion'
        message: 'Cognito region'
        default: 'eu-west-1'
      }
      {
        type: 'input'
        name: 'cognitoUserPoolId'
        message: 'Cognito user pool id'
      }
      {
        type: 'input'
        name: 'cognitoWebClientId'
        message: 'Cognito web client id'
      }
      {
        type: 'input'
        name: 'cloudinaryId'
        message: 'Cloudinary user id'
      }
      {
        type: 'input'
        name: 'cloudinaryPreset'
        message: 'Cloudinary upload preset'
      }

    ], (answers) =>
      @filters =
        settings: answers
      @filters.settings.appName = @name
      cb()
  checkForConfig: ->
    cb = @async()
    if @config.get('filters')
      @log 'The generator has already been run'
      return
    if fs.existsSync(process.cwd() + '/' + @filters.settings.appName)
      @log 'The generator has already been run.  CD into the directory'
      return
    cb()
    return
  write: ->
    cb = @async()
    @filters.settings.gitname = @user.git.name()
    @filters.settings.gitemail = @user.git.email()
    fs.mkdirSync @filters.settings.appName
    process.chdir process.cwd() + '/' + @filters.settings.appName
    @sourceRoot @templatePath('/')
    @destinationRoot process.cwd()
    @config.set 'filters', @filters
    @config.set 'appname', @filters.settings.appName
    utils.write this, @filters, cb
  end: ->
    cb = @async()
    console.log 'install dev deps'
    utils.spawnSync 'npm', ['install', '--save-dev', 'coffee-loader', 'coffeescript', 'css-loader', 'file-loader', 'html-webpack-plugin', 'image-webpack-loader', 'pug', 'pug-loader', 'replace-in-file', 'style-loader', 'stylus', 'stylus-loader', 'webpack', 'webpack-cli', 'webpack-dev-server', 'webpack-merge'], ->
      utils.spawnSync 'npm', ['install', '--save', 'aws-amplify', 'cloudinary-core', 'is-mobile'], cb
