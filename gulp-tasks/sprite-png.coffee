file_manager    = require './file_manager.coffee'
gulp            = require('gulp')
spritesmith       = require('gulp.spritesmith')

#plugins requires

file_manager      = require './file_manager.coffee'


gulp.task 'spritePng', ->
  spriteData = gulp.src( file_manager.source + '/images/ico_png/*.png')

  .pipe spritesmith (
    imgName: 'sprite-png.png'
    cssName: '_sprite-png.sass'
    imgPath: '../images/sprite-png.png'
    padding: 10
  )

  spriteData.img
    .pipe gulp.dest(file_manager.source + '/images/')

  spriteData.css
    .pipe gulp.dest(file_manager.source + '/sass/base/mixins')