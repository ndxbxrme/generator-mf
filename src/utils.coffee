'use strict'
spawn = require 'cross-spawn'
glob = require 'glob'
fs = require 'fs'


spawnSync = (command, args, cb) ->
  result = spawn command, args, stdio:'inherit'
  poll = ->
    if result._closesGot == 1
      cb?()
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
          fs.mkdirSync yeoman.destinationPath(f)
          continue
        console.log 'writing', f
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
