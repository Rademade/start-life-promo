gulp              = require 'gulp'
file_manager      = require './file_manager.coffee'

###
  Manifest tasks
###

gulp.task 'manifest', -> exec file_manager.build
gulp.task 'manifest:build', -> exec file_manager.build


exec = (build_dir)->
  gulp
    .src("#{file_manager.source}/extension/*")
    .pipe gulp.dest("#{build_dir}")

