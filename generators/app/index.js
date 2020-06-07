// Generated by CoffeeScript 2.5.1
(function() {
  var fs, utils, yeoman;

  yeoman = require('yeoman-generator');

  utils = require('../utils.js');

  fs = require('fs');

  module.exports = yeoman.generators.Base.extend({
    init: function() {
      return this.argument('name', {
        type: String,
        required: true
      });
    },
    prompts: function() {
      var cb;
      cb = this.async();
      return this.prompt([
        {
          type: 'input',
          name: 'displayName',
          message: 'Display name',
          default: this.name
        },
        {
          type: 'input',
          name: 'productPrefix',
          message: 'Product prefix, eg com.rainstormweb',
          default: 'com.rainstormweb'
        },
        {
          type: 'input',
          name: 's3bucket',
          message: 'S3 bucket for deployment',
          default: 's3://www.rainstormweb.com/' + this.name
        },
        {
          type: 'input',
          name: 'apiName',
          message: 'API name'
        },
        {
          type: 'input',
          name: 'apiUrl',
          message: 'API url'
        },
        {
          type: 'input',
          name: 'cognitoRegion',
          message: 'Cognito region',
          default: 'eu-west-1'
        },
        {
          type: 'input',
          name: 'cognitoUserPoolId',
          message: 'Cognito user pool id'
        },
        {
          type: 'input',
          name: 'cognitoWebClientId',
          message: 'Cognito web client id'
        },
        {
          type: 'input',
          name: 'cloudinaryId',
          message: 'Cloudinary user id'
        },
        {
          type: 'input',
          name: 'cloudinaryPreset',
          message: 'Cloudinary upload preset'
        }
      ], (answers) => {
        this.filters = {
          settings: answers
        };
        this.filters.settings.appName = this.name;
        return cb();
      });
    },
    checkForConfig: function() {
      var cb;
      cb = this.async();
      if (this.config.get('filters')) {
        this.log('The generator has already been run');
        return;
      }
      if (fs.existsSync(process.cwd() + '/' + this.filters.settings.appName)) {
        this.log('The generator has already been run.  CD into the directory');
        return;
      }
      cb();
    },
    write: function() {
      var cb;
      cb = this.async();
      this.filters.settings.gitname = this.user.git.name();
      this.filters.settings.gitemail = this.user.git.email();
      fs.mkdirSync(this.filters.settings.appName);
      process.chdir(process.cwd() + '/' + this.filters.settings.appName);
      this.sourceRoot(this.templatePath('/'));
      this.destinationRoot(process.cwd());
      this.config.set('filters', this.filters);
      this.config.set('appname', this.filters.settings.appName);
      return utils.write(this, this.filters, cb);
    },
    end: function() {
      var cb;
      cb = this.async();
      console.log('install dev deps');
      return utils.spawnSync('npm', ['install', '--save-dev', 'coffee-loader', 'coffeescript', 'css-loader', 'file-loader', 'html-webpack-plugin', 'image-webpack-loader', 'pug', 'pug-loader', 'replace-in-file', 'style-loader', 'stylus', 'stylus-loader', 'webpack', 'webpack-cli', 'webpack-dev-server', 'webpack-merge'], function() {
        return utils.spawnSync('npm', ['install', '--save', 'aws-amplify', 'cloudinary-core', 'is-mobile'], cb);
      });
    }
  });

}).call(this);
