file_manager      = require './file_manager.coffee'
gulp              = require 'gulp'
concat            = require 'gulp-concat'
wrap              = require 'gulp-wrap'
declare           = require 'gulp-declare'
jade              = require 'gulp-jade'

###
  Templates tasks
###

gulp.task 'templates', ->
  compileTemplates 'templates.js', file_manager.build_js

nameProcessor = (filePath) ->
  declare.processNameByPath(
    filePath
      .replace("#{file_manager.source}/templates", '')
      .replace("#{file_manager.source}/js/directives", '')
  ).replace /\./g, '/'

compileTemplates = (name, destination) ->
  gulp
    .src [
      "#{file_manager.source}/templates/**/*.jade"
      "#{file_manager.source}/js/directives/**/*.jade"
    ]
    .pipe jade(
      debug: no
      client: true
    )
    .pipe wrap('(<%= contents %>)()')
    .pipe declare(
      namespace: 'Templates',
      noRedeclare: yes,
      processName: nameProcessor
    )
    .pipe concat(name)
    .pipe gulp.dest(destination)
