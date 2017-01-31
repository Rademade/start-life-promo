#plugins requires
gulp                = require('gulp')
jade                = require('gulp-jade')
livereload          = require('gulp-livereload')

path = require './path.coffee'
gulp.task 'jade', ->
  gulp
    .src(path.inputDir + 'templates/**/*.jade')
    .pipe(jade(
      pretty: true
    ))
    .pipe(gulp.dest(path.outputDir))
    .pipe livereload()