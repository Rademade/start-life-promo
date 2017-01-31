app.directive 'homeAdvancedSearch', ->
  restrict : 'A'
  controller : 'homeAdvancedSearchController'
  controllerAs : 'homeAdvancedSearchCtrl'
  templateUrl : 'home/advanced-search/template'
  scope :
    selectors : '='
