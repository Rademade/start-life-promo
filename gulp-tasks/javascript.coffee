_                 = require 'lodash'
file_manager      = require './file_manager'
gulp              = require 'gulp'
concat            = require 'gulp-concat'
manifests         = require './javascript-manifests'
coffee            = require 'gulp-coffee'
plumber           = require 'gulp-plumber'
preprocess        = require 'gulp-preprocess'
config            = require './config'
Q                 = require 'q'
uglify            = require 'gulp-uglify'

###
  JavaScript tasks
###

gulp.task 'javascript:application', ->
  collectJavaScript manifests.application(), 'application.js', file_manager.build_js, coffee: yes

gulp.task 'javascript:vendor', ->
  collectJavaScript manifests.vendor(), 'vendor.js', file_manager.build_js, coffee: no

gulp.task 'javascript', [
  'javascript:vendor'
  'javascript:application'
  'templates'
]

gulp.task 'javascript:build', ['javascript'], ->
  deferred = Q.defer()

  fileName = 'app.min.js'

  collectJavaScript(
    manifests.build()
    fileName
    file_manager.build_js
    {coffee: no, compress: no}
  ).on 'end', ->
    file_manager.hashifyFile(file_manager.build_js, fileName).then ->
      file_manager.removeFile(manifests.build(), deferred)

  deferred.promise

###
  JavaScript private methods
###

collectJavaScript = (source, name, destination, opts = {}) ->
  stream = gulp.src source

  stream = stream.pipe plumber()

  stream = stream.pipe coffee(bare: no) if opts.coffee
  stream = stream.pipe uglify() if opts.compress
  stream = stream.pipe preprocess( context: config.getConfig() )
  stream = stream.pipe concat(name)

  stream = stream.pipe(gulp.dest(destination))
