file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
del 			        = require 'del'

###
  Clean tasks
###

gulp.task 'clean', [], -> del.sync(file_manager.build)