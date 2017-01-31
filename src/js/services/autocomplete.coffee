app.service 'autocomplete', [
  'Autocomplete', 'AutocompleteNginx', '$q', '$http', 'Airport',
  (Autocomplete, AutocompleteNginx, $q, $http, Airport) ->

    # keys for search autocomplete
    AMAZON = 'amazon'
    GOOGLE = 'google'
    GOOGLE_MAPS = 'google-maps'
    GOOGLE_PLAY = 'google-play'
    BING = 'bing'
    BING_MAPS = 'bing-maps'
    IMDB = 'imdb'
    ESPN = 'espn'
    EBAY = 'ebay'
    WIKIPEDIA = 'wikipedia'
    YAHOO = 'yahoo'
    YOUTUBE = 'youtube'

    # keys for flight direction autocomplete
    AIRPORT = 'airport'

    # keys for car search autocomplete
    CARS = 'cars'

    # keys for home location autocomplete
    REALTOR = 'realtor'

    autocompleteUrls = {}

    # autocompletes for search
    autocompleteUrls[GOOGLE] = (query) ->
      default : "http://suggestqueries.google.com/complete/search?client=firefox&q=#{query}"
      nginx :
        route : 'autocomplete/google/search'
        params :
          client : 'firefox'
          q : query

    autocompleteUrls[GOOGLE_MAPS] = (query) ->
      default : "https://maps.googleapis.com/maps/api/geocode/json?address=#{query}"
      nginx : no

    autocompleteUrls[BING_MAPS] = (query) ->
      default : "https://maps.googleapis.com/maps/api/geocode/json?address=#{query}"
      nginx : no

    autocompleteUrls[GOOGLE_PLAY] = (query) ->
      nginx :
        route : 'autocomplete/google-play/search'
        params :
          json : 1
          query : query

    autocompleteUrls[YAHOO] = (query) ->
      default : "https://search.yahoo.com/sugg/gossip/gossip-us-ura/?output=sd1&command=#{query}"
      nginx :
        route : 'autocomplete/yahoo/search'
        params :
          output : 'sd1'
          command : query

    autocompleteUrls[YOUTUBE] = (query) ->
      default : "http://clients1.google.com/complete/search?client=youtube&q=#{query}"
      nginx :
        route : 'autocomplete/youtube/search'
        params :
          client : 'youtube'
          'gs_ri' : 'youtube'
          q : query

    autocompleteUrls[WIKIPEDIA] = (query) ->
      default : "https://en.wikipedia.org/w/api.php?format=json&action=opensearch&search=#{query}"
      nginx :
        route : 'autocomplete/wikipedia/search'
        params :
          format : 'json'
          action : 'opensearch'
          search : query

    autocompleteUrls[IMDB] = (query) ->
      letter = query[0]
      query = query.split(' ')[0]
      default : "http://sg.media-imdb.com/suggests/#{letter}/#{query}.json"
      nginx :
        route : "autocomplete/imdb/search/#{letter}/#{query}.json"
        params : {}

    autocompleteUrls[ESPN] = (query) ->
      default : "http://api-app.espn.go.com/search/lib/displayAutoCompleteV2?q=#{query}&results=10"
      nginx :
        route : 'autocomplete/espn/search'
        params :
          q : query
          results : 10

    autocompleteUrls[EBAY] = (query) ->
      default : "http://anywhere.ebay.com/services/suggest/?v=json&q=#{query}"
      nginx :
        route : 'autocomplete/ebay/search'
        params :
          q : query
          v : 'json'

    autocompleteUrls[BING] = (query) ->
      default : "https://www.bing.com/AS/Suggestions?qry=#{query}&cvid=B1F72932231447F4B9B6A1A0AEAFD4A9"
      nginx :
        route : 'autocomplete/bing/search'
        params :
          qry : query
          cvid : 'B1F72932231447F4B9B6A1A0AEAFD4A9'

    autocompleteUrls[AMAZON] = (query) ->
      default : "http://completion.amazon.com/search/complete?mkt=1&search-alias=aps&q=#{query}"
      nginx :
        route : 'autocomplete/amazon/search'
        params :
          mkt : 1
          'search-alias' : 'aps'
          q : query

    # car makes and models
    autocompleteUrls[CARS] = (query) ->
      default : 'http://cars.com/ajax/mvis/2.0/rest/dropDownData'
      nginx :
        route : 'autocomplete/cars/search'
        params : {}

    # home location
    autocompleteUrls[REALTOR] = (query) ->
      default : "http://autocomplete.api.move.com/AutoCompleteApi/autocomplete/suggest?input=#{query}&area_types=neighborhood,city,county,postal_code,address"
      nginx :
        route : 'autocomplete/realtor/search'
        params :
          input : query
          'area_types' : 'neighborhood,city,county,postal_code,address'

    # autocompletes for flight direction
    autocompleteUrls[AIRPORT] = (query) ->
      localModel:
        Airport.getAutocomplete(query)

    # if you want to test autocomplete data on local mathine
    # just set key 'testMode' = yes
    get : (provider, query = '', testMode = no) ->
      autocompletePromise = $q.defer()
      query = query.replace(/ +(?= )/g, '')
      provider = GOOGLE unless autocompleteUrls[provider]
      provider = GOOGLE_MAPS if provider is BING_MAPS
      provider = AMAZON if provider is EBAY
      url = autocompleteUrls[provider](query)

      if testMode
        new Autocomplete().put(link : url.default).then (data) =>
          autocompletePromise.resolve @parse(data, provider)
      else
        if url.nginx
          new AutocompleteNginx().get(url.nginx.route, url.nginx.params).then (data) =>
            autocompletePromise.resolve @parse(data, provider)
        else if url.localModel
          url.localModel.then (data) =>
            autocompletePromise.resolve @parse(data, provider)
        else
          $http.get(url.default).then (data) =>
            autocompletePromise.resolve @parse(data, provider)

      autocompletePromise.promise

    parse : (data, provider) ->
      switch provider
        when GOOGLE_MAPS
          words = _.map data.data.results, (result) -> result.formatted_address
          words = _.map _.flatten(words), (word) -> text : word
          _.uniqBy words, 'text'

        when GOOGLE_PLAY
          _.map data, (item) ->
            text : item.s

        when YAHOO
          _.map data.r, (item) ->
            text : item.k

        when YOUTUBE
          _.map @getArrayFromString(data)[1], (item) ->
            text : item[0]

        when AIRPORT
          _.map data, (item) ->
            text : item.text
            airportCode : item.airport_code
            id : item.id

        when CARS
          _.map data.mk, (item) ->
            name : item.nm
            models : _.map item.md, (item) ->
              name : item.nm
              id : item.id
            id : item.id

        when REALTOR
          data.autocomplete

        when BING
          html = data.split('<script')[0]
          if html
            el = angular.element(html)
            _.map el[0].childNodes, (node) ->
              text : node.attributes.query.value

        when IMDB
          if data.error
            []
          else
            data = data.replace('imdb$l', '')
            data = data.substring(1, data.length - 1)
            _.map JSON.parse(data).d, (item) ->
              text : item.l

        when ESPN
          _.map data, (item) ->
            text : item.value

        else
          _.map data[1], (item) ->
            text : item

    getArrayFromString : (str) ->
      JSON.parse(str.match(/\[([^)]+)\]/)[0])

]
