app.directive 'newsPreview', ->
  restrict : 'A'
  controller : 'newsPreviewController'
  controllerAs : 'newsPreviewCtrl'
  templateUrl : 'news/preview/template'
  scope :
    service : '='
