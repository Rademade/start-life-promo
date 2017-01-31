app.directive 'autoAdvancedSearch', ->
  restrict : 'A'
  controller : 'autoAdvancedSearchController'
  controllerAs : 'autoAdvancedSearchCtrl'
  templateUrl : 'auto/advanced-search/template'
  scope :
    factory : '='
