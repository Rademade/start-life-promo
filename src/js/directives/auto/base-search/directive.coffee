app.directive 'autoBaseSearch', ->
  restrict : 'A'
  controller : 'autoBaseSearchController'
  controllerAs : 'autoBaseSearchCtrl'
  templateUrl : 'auto/base-search/template'
  scope :
    factory : '='
