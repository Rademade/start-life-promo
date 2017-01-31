app.controller 'ApplicationController', [
  'gmail', 'synchronization', 'newsService', 'searchTabService', 'TravelFactory', '$state',
  (gmail, synchronization, newsService, searchTabService, TravelFactory, $state) ->

    @travelFactory = new TravelFactory()

    @searchTabService = searchTabService
    @newsService = newsService
    @sync = synchronization

    @isRequestPending = () ->
      window.isRequestPending()

    window.onGoogleApiLoad = () ->
      gmail.init()

    return

]
