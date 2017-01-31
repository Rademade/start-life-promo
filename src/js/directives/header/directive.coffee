app.directive 'header', ->
  restrict : 'A'
  controller : 'headerController'
  controllerAs : 'headerCtrl'
  templateUrl : 'header/template'
  scope :
    sync : '='
