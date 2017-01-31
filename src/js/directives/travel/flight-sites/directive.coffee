app.directive 'flightSites', ->
  restrict : 'A'
  controller: 'flightSitesController'
  controllerAs: 'flightSitesCtrl'
  templateUrl: 'travel/flight-sites/template'
  scope :
    onClickCb : '&'
