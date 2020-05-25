mobile = require 'is-mobile'
module.exports = (app) ->
  Object.assign app,
    templates:
      signin: require('./components/signin/signin.pug')
      dashboard: require('./components/dashboard/dashboard.pug')
    controllers:
      signin: require('./components/signin/signin.coffee')
      dashboard: require('./components/dashboard/dashboard.coffee')
    imageUploader: require('./components/image-uploader/image-uploader.coffee')
    formValidator: require('./components/form-validator/form-validator.coffee')
    passwordValidator: require('./components/form-validator/password.coffee')
    thumbnail: require('./components/thumbnail/thumbnail.coffee')
    version: require('../package.json').version
  if mobile()
    app.templates = {
      ...app.templates,
      dashboard: require('./components/dashboard/dashboard-mobile.pug')
    }
  console.log app
