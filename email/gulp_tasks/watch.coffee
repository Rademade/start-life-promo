#plugins requires
gulp          = require('gulp')
watch         = require('gulp-watch')
livereload    = require('gulp-livereload')

path = require './path.coffee'

gulp.task 'watch', ->
  gulp.watch path.inputDir + 'templates/**/*.jade', ['jade']
  livereload.listen()