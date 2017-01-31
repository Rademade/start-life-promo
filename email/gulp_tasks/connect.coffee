#plugins requires
gulp        = require('gulp')
connect     = require('gulp-connect')

path = require './path.coffee'


gulp.task 'connect', ->
  connect.server
    root: [ path.outputDir ]
    port: 3000