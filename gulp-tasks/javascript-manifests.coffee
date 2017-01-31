module.exports = (->

  file_manager      = require './file_manager.coffee'

  manifests = {}

  manifests.vendor = ->
    file_manager.rootify [
      'angular/angular'
      'angular-sanitize/angular-sanitize'
      'lodash/lodash'
      'angular-ui-router/release/angular-ui-router'
      'angular-sanitize/angular-sanitize'
      'angularjs-rails-resource/angularjs-rails-resource'
      'angular-translate/angular-translate'
      'angular-youtube-mb/src/angular-youtube-embed'
      'ngstorage/ngStorage'
      'angucomplete-alt/angucomplete-alt'
      'x2js/xml2json'
      'angular-xml/angular-xml'
      'angular-cookies/angular-cookies'
      're-tree/re-tree'
      'ng-device-detector/ng-device-detector'
      'Sortable/Sortable'
      'Sortable/ng-sortable'
      'ng-autocomplete-commonjs/src/ngAutocomplete'
    ], "bower_components", 'js'

  manifests.application = ->
    file_manager.rootify [
      "app"
      "router"
      "**/*"
    ], "#{file_manager.source}/js", 'coffee'


  manifests.build = ->
    file_manager.rootify [
      "vendor"
      "templates"
      "application"
    ], file_manager.build_js, 'js'

  manifests

)()
