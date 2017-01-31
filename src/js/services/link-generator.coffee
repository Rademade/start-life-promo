app.service 'linkGenerator', [ () ->

  API_PREFIX = '/* @echo apiPrefix */'

  LINKS_PREFIXES =
    flight : '/links/flight?'
    hotel : '/links/hotel?'
    auto : '/links/auto?'
    home : '/links/home?'

  getLink : (params, prefix) ->
    url = API_PREFIX + LINKS_PREFIXES[prefix]
    _.each params, (value, key) ->
      if value
        url += "&#{key}=#{value}"
      yes
    url

  getFlightLink : (params) ->
    url = API_PREFIX + LINKS_PREFIXES['flight']
    _.each params, (value, key) ->
      if value
        switch key
          when 'passengers'
            _.each value, (passanger) ->
              url += "&#{passanger.name}=#{passanger.count}"
              yes
          when 'flights'
            _.each value, (flight) ->
              _.each flight, (value, key) ->
                if value
                  url += "&flights[][#{key}]=#{value}"
                yes
              yes
          else
            url += "&#{key}=#{value}"
      yes
    url

  getAutoLink : (params) ->
    url = API_PREFIX + LINKS_PREFIXES['auto']
    _.each params, (value, key) ->
      if value
        switch key
          when 'make'
            url += "&make_name=#{value.name}&make_id=#{value.id}"
          when 'model'
            url += "&model_name=#{value.name}&model_id=#{value.id}"
          else
            url += "&#{key}=#{value}"
      yes
    url

  getHotelLink : (params) ->
    @getLink(params, 'hotel')

  getHomeLink : (params) ->
    @getLink(params, 'home')

]
