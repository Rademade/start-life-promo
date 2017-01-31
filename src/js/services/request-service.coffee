app.service 'requestService', [
  '$localStorage', '$q', 'Request', 'searchTabService',
  ($localStorage, $q, Request, searchTabService) ->

    DOMAINS = searchTabService.getDomains()
    DEFAULT_DOMAIN = 'google.com'

    MAX_TEXT_WORDS_COUNT = 5
    MAX_TEXT_LENGTH = 50
    MAX_REQUESTS_BUFFER_COUNT = 5

    DAY = 24 * 60 * 60 * 1000
    LAST_UPDATE = $localStorage['lastRequestsUpdateTime'] || no
    TIME_NOW = (new Date()).getTime()
    UPDATE_INTERVAL = 7 * DAY

    isUpdateNeed : ->
      unless LAST_UPDATE
        requests = []
        _.each DOMAINS, (domain) ->
          requests.push
            domain : domain
            requests : []
          yes
        $localStorage['requests'] = requests
        $localStorage['requestsBuffer'] = _.cloneDeep requests
      TIME_NOW > LAST_UPDATE + UPDATE_INTERVAL

    serialize : (requests) ->
      data = []
      _.each DOMAINS, (domain) =>
        data.push
          domain : domain
          requests : _.filter(requests, (request) -> request.domain is domain)
        yes
      data

    getRequests : ->
      requestsPromise = $q.defer()
      if @isUpdateNeed()
        Request.getAll().then (requests) =>
          $localStorage['requests'] = @serialize(requests)
          $localStorage['lastRequestsUpdateTime'] = TIME_NOW
          requestsPromise.resolve @filter($localStorage['requests'])
      else
        requestsPromise.resolve @filter($localStorage['requests'])
      requestsPromise.promise

    filter : (requests) ->
      if requests
        _.find(requests, (request) => request.domain is @getCurrentDomain()).requests

    save : (text, items) ->
      text = @truncateExtraSpaces(text).toLowerCase()
      if @isTextValid(text) && @isNewRequest(text)
        _.each items, (item) =>
          @addToBuffer(text, item.domain)

    addToBuffer : (text, domain) ->
      _.each $localStorage['requestsBuffer'], (request) =>
        if request.domain is domain
          request.requests.push
            text : text
          if request.requests.length >= MAX_REQUESTS_BUFFER_COUNT
            @loadRequestsOnServer(request.requests, domain)
        yes

    loadRequestsOnServer : (requests, domain) ->
      new Request({ list : requests, domain : domain }).create().then () =>
        @clearBuffer(domain)

    clearBuffer : (domain) ->
      _.each $localStorage['requestsBuffer'], (request) ->
        if request.domain is domain
          request.requests = []
          yes

    isTextValid : (text) ->
      @wordCount(text) <= MAX_TEXT_WORDS_COUNT && @truncateSpaces(text).length <= MAX_TEXT_LENGTH

    isNewRequest : (text) ->
      requests = @filter($localStorage['requestsBuffer'])
      _.isEmpty(_.find(requests, (request) -> request.text is text))

    wordCount : (text) ->
      (text.match(/ /g) || []).length + 1

    truncateSpaces : (text) ->
      if text then text.replace(/\s/g, '') else ''

    truncateExtraSpaces : (text) ->
      if text then text.replace(/ +(?= )/g, '') else ''

    getCurrentDomain : ->
      searchTabService.getCurrentTab().domain

]
