gulp              = require 'gulp'

gulp.task 'build', ['clean'], ->
  gulp.start ['fonts:css'], ->
    gulp.start ['fonts:js'], ->
      gulp.start ['javascript'], ->
        gulp.start ['sprite'], ->
          gulp.start ['spritePng'], ->
            gulp.start ['stylesheets'], ->
              gulp.start ['layout'], ->
                gulp.start ['manifest'], ->
                  console.log('Build finished')

gulp.task 'build:production', ['clean'], ->
  gulp.start ['fonts:css'], ->
    gulp.start ['fonts:js'], ->
      gulp.start ['javascript:build'], ->
        gulp.start ['sprite'], ->
          gulp.start ['spritePng'], ->
            gulp.start ['stylesheets:build'], ->
              gulp.start ['layout:build'], ->
                gulp.start ['manifest'], ->
                  console.log('Build finished')
