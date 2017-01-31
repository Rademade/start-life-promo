app.directive 'hotels', ->
  restrict : 'A'
  controller: 'hotelsController'
  controllerAs: 'hotelsCtrl'
  templateUrl: 'travel/hotels/template'
  scope :
    syncService : '='
