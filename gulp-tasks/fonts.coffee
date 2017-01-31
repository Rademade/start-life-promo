gulp              = require 'gulp'
file_manager      = require './file_manager.coffee'

###
  Images tasks
###

gulp.task 'fonts:css', ->
  gulp
  .src( "#{file_manager.source}/fonts/css/fonts.css" )
  .pipe gulp.dest("#{file_manager.build}/css")

gulp.task 'fonts:js', -> exec file_manager.build

exec = (build_dir)->
  gulp
  .src( "#{file_manager.source}/fonts/js/fonts.js" )
  .pipe gulp.dest("#{build_dir}/js")