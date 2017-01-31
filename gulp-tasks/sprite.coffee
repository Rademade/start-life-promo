file_manager    = require './file_manager.coffee'
gulp            = require('gulp')
svgSprite       = require('gulp-svg-sprite')
svgmin          = require('gulp-svgmin')

config =
  shape:
    spacing:
      padding: 1
      box: 'content'

    transform: ['svgo']

  mode:
    css:
      dest: '../'
      sprite: 'images/sprite.svg'
      bust: false
      render: scss:
        dest: 'sass/base/mixins/_sprite-svg.scss'

gulp.task 'sprite', ->
  return gulp.src(file_manager.source + '/images/ico/*.svg')
    .pipe(svgmin())
    .pipe(svgSprite(config))
    .pipe(gulp.dest(file_manager.source + '/images/'))