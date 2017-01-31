app.directive 'bookmarks', ->
  restrict : 'A'
  controller : 'bookmarksController'
  controllerAs : 'bookmarksCtrl'
  templateUrl : 'bookmarks/list/template'
  scope :
    sync : '='
