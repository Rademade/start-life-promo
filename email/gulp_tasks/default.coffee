#plugins requires
gulp = require('gulp')

path = require './path.coffee'

gulp.task 'default', [
  'jade',
  'connect',
  'watch'
]
