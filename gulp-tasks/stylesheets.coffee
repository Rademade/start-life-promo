file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
sass              = require 'gulp-sass'
autoprefixer      = require 'gulp-autoprefixer'
concat            = require 'gulp-concat'
cssmin            = require 'gulp-cssmin'
plumber           = require 'gulp-plumber'
Q                 = require 'q'

###
  Stylesheets task
###

gulp.task 'stylesheets', ['images'], ->
  compileStylesheets {
    root: file_manager.build
    styles: file_manager.build_css
    images: file_manager.build_images
  }, 'stylesheets.css'


###
  Stylesheets build task
###

gulp.task 'stylesheets:build', ['images'], ->
  deferred = Q.defer()

  fileName = 'stylesheets.min.css'

  compileStylesheets( {
    root: file_manager.build
    styles: file_manager.build_css
    images: file_manager.build_images
  }, fileName, compress: true).then ->
    file_manager.hashifyFile(file_manager.build_css, fileName, deferred)

  deferred.promise


###
  Private methods
###
#err             = sass.logError

compileStylesheets = (buildDirs, name, opts = {}) ->
  file_name = 'manifest'

  deferred = Q.defer()

  stream = gulp
    .src("#{file_manager.source}/sass/#{file_name}.sass")
    .pipe sass(
        indentedSyntax: true
        cache: false
      ).on('error', sass.logError)
    .pipe autoprefixer(
        browsers: ['> 0%']
      )
    .pipe gulp.dest(file_manager.build_css)
  stream = stream.pipe cssmin( advanced: false ) if opts.compress
  stream = stream.pipe concat(name)
  stream = stream.pipe gulp.dest(buildDirs.styles)

  stream.on 'end', -> file_manager.removeFile("#{buildDirs.styles}/#{file_name}.css", deferred)

  deferred.promise
