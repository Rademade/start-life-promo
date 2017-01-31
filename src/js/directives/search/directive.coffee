app.directive 'search', ->
  restrict : 'A'
  controller : 'searchController'
  controllerAs : 'searchCtrl'
  templateUrl : 'search/template'
  scope :
    sync : '='
