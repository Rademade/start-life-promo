app.controller 'flightSitesController', [ '$scope', 'linkOpener', ($scope, linkOpener) ->

  @sites = [
    { name : 'Expedia.com', link : 'https://www.expedia.com/' },
    { name : 'Kayak.com', link : 'https://www.kayak.com/' },
    { name : 'Orbitz.com', link : 'https://www.orbitz.com/' },
    { name : 'Priceline.com', link : 'https://www.priceline.com/home/' },
    { name : 'Cheapflights.com', link : 'http://ww2.cheapflights.com/' }
  ]

  @open = (site) ->
    $scope.onClickCb(site : site.name)

  @openLink = (site) ->
    linkOpener.open(site.link)

  return

]
