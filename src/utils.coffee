'use strict'
spawn = require 'cross-spawn'
glob = require 'glob'
fs = require 'fs'


spawnSync = (command, args, cb) ->
  new Promise (resolve, reject) ->
    result = spawn command, args, stdio:'inherit'
    poll = ->
      if result._closesGot == 1
        cb?()
        resolve()
      else
        setTimeout poll, 500
      return

    poll()
    return

write = (yeoman, options, cb) ->
  files = glob '**',
    dot: true
    cwd: yeoman.sourceRoot()
  , (err, files) ->
    for f in files
      name = f
      allGood = true
      if f.indexOf('(') isnt - 1
        allGood = false
        foundFilter = false
        for filter of yeoman.filters.settings
          if f.indexOf("(#{filter})") isnt -1
            allGood = true
            foundFilter = true
            name = f.replace "(#{filter})", ''
            break
      if allGood
        if fs.lstatSync(yeoman.templatePath(f)).isDirectory()
          try
            fs.mkdirSync yeoman.destinationPath(f)
          continue
        try
          await spawnSync 'rm', ['-rf', yeoman.destinationPath(name.replace('compname', yeoman.compname))]
        if /\.png$/.test yeoman.templatePath(f)
          fs.copyFileSync yeoman.templatePath(f), yeoman.destinationPath(name.replace('compname', yeoman.compname))
        else
          try
            yeoman.fs.copyTpl yeoman.templatePath(f), yeoman.destinationPath(name.replace('compname', yeoman.compname)), options
          catch e
            fs.copyFileSync yeoman.templatePath(f), yeoman.destinationPath(name.replace('compname', yeoman.compname))
    cb?()

launchGrunt = (yeoman) ->
  yeoman.log ''
  yeoman.log 'Your app has been built'
  yeoman.log 'CD into ' + yeoman.filters.settings.appName + '/'

module.exports =
  spawnSync: spawnSync
  write: write
  launchGrunt: launchGrunt
