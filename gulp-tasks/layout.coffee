file_manager      = require './file_manager.coffee'
config            = require './config.coffee'
gulp              = require 'gulp'
rename            = require 'gulp-rename'
preprocess        = require 'gulp-preprocess'
inject            = require 'gulp-inject'
jade              = require 'gulp-jade'
series            = require 'stream-series'

gulp.task 'layout', ->
  vendor_js = gulp.src ["#{file_manager.build}/js/vendor.js"], read: false
  templates_js = gulp.src ["#{file_manager.build}/js/templates.js"], read: false
  application_js = gulp.src ["#{file_manager.build}/js/application.js"], read: false
  fonts_js = gulp.src ["#{file_manager.build}/js/fonts.js"], read: false
  styles = gulp.src ["#{file_manager.build}/**/*.css"], read: false
  build(series(styles, vendor_js, templates_js, application_js, fonts_js ), file_manager.build)

gulp.task 'layout:build', ->
  js = gulp.src ["#{file_manager.build}/**/*.js"], read: false
  css = gulp.src ["#{file_manager.build}/**/*.css"], read: false
  build(series(css, js), file_manager.build)

build = (sources, dir_path)->
  gulp
    .src "#{file_manager.source}/server/layout.jade"
    .pipe(jade())
    .pipe preprocess()
    .pipe inject(sources,
      addRootSlash: config.getConfig().addRootSlash
      ignorePath: dir_path
    )
    .pipe rename('index.html')
    .pipe gulp.dest(dir_path)