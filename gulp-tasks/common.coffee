file_manager      = require './file_manager.coffee'
config            = require './config.coffee'
gulp              = require 'gulp'
concat            = require 'gulp-concat'
nodemon           = require 'gulp-nodemon'

# Set config version
config.setVersion(process.env.VERSION) if process.env.VERSION

# Set config settings
config.setConfig(JSON.parse(process.env.BUILD_CONFIG)) if process.env.BUILD_CONFIG


# Base tasks
gulp.task 'default', ->
  gulp.start ['build', 'watch', 'server'], ->
    console.log('Run')

gulp.task 'watch', ->
  # Styles
  gulp.watch [
    "#{file_manager.source}/sass/**/*"
  ], { interval : 500 }, ['stylesheets']
  # Images
  gulp.watch [
    "#{file_manager.source}/images/**/*"
  ], { interval : 500 }, ['images']
  # Application
  gulp.watch [
    "#{file_manager.source}/js/**/*"
  ], { interval : 500 }, ['javascript:application']
  # Layout
  gulp.watch [
    "#{file_manager.source}/views/**/*"
  ], { interval : 500 }, ['layout']
  # Templates
  gulp.watch [
    "#{file_manager.source}/templates/**/*"
    "#{file_manager.source}/js/directives/**/*"
  ], { interval : 500 }, ['templates']
  # Manifest
  gulp.watch [
    "#{file_manager.source}/extension/*"
  ], { interval : 500 }, ['manifest']
