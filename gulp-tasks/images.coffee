gulp              = require 'gulp'
file_manager      = require './file_manager.coffee'

###
  Images tasks
###

gulp.task 'images', -> exec file_manager.build
gulp.task 'images:build', -> exec file_manager.build


exec = (build_dir)->
  gulp
    .src( "#{file_manager.source}/images/**/*" )
    .pipe gulp.dest("#{build_dir}/images")