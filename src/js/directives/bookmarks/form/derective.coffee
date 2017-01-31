app.directive 'bookmarkForm', ->
  restrict : 'A'
  controller : 'bookmarkFormController'
  controllerAs : 'bookmarkFormCtrl'
  templateUrl : 'bookmarks/form/template'
  scope :
    bookmark : '='
    service : '='
    onSaveCb : '&'
