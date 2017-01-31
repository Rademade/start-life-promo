_                 = require 'lodash'
Q                 = require 'q'
gulp              = require 'gulp'
md5               = require 'gulp-md5'
del               = require 'del'


module.exports =
  source:         'src'
  build:          'www'
  build_js:       'www/js'
  build_images:   'www/images'
  build_css:      'www/css'

  rootify: (targets, root, extension = null) ->
    targets.map (target) ->
      root + '/' + target + if extension then ".#{extension}" else ''

  hashifyFile: (directory, filename, deferred = Q.defer())->

    full_source_path = "#{directory}/#{filename}"

    gulp
      .src full_source_path
      .pipe md5()
      .pipe gulp.dest directory
      .on 'end', => @removeFile(full_source_path, deferred)

    deferred.promise

  removeFile: (file_path, deferred) ->
    files = if _.isArray(file_path) then file_path else [file_path]
    del(files, -> deferred.resolve())