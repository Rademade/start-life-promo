app.directive 'siteSelect', ->
  restrict : 'A'
  controller : 'siteSelectController'
  controllerAs : 'siteSelectCtrl'
  templateUrl : 'select/site/template'
  scope :
    selector : '='
    onSelectedCb : '&'
    currentId : '='
    onChangeCb : '&'
