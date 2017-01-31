app.directive 'location', ->
  restrict : 'A'
  controller : 'locationController'
  controllerAs : 'locationCtrl'
  templateUrl : 'home/location/template'
  scope :
    placeholder : '@'
    searchSite : '@'
    service : '='
    errorMessage : '='
    focus : '='
