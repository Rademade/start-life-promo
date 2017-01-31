file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
nodemon           = require 'gulp-nodemon'

gulp.task 'server', ->
  nodemon
    script: 'server.js'
    ext: 'coffee js html jade'
    ignore: [
      "#{file_manager.build}/**/*",
      "#{file_manager.public}/**/*",
      "#{file_manager.source}/**/*",
      'gulpfile.js',
      'gulpfile.coffee'
      'gulpfile.server'
    ]
  .on 'restart', ->
    console.log 'Express server restarted'