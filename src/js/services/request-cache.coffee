app.factory 'RequestCache', [ '$q', ($q) ->

  class RequestCache

    constructor : (Model, getter = 'query', getterArgs = []) ->
      @Model = Model
      @getter = getter
      @getterArgs = getterArgs
      @delayedPromise = null
      @inProggress = false
      @data = null

    getData : () ->
      return @_getDelayedData() if @inProggress
      @inProggress = true
      return @_getCachedData() unless @_isCached()
      return @_getFreshData()

    _isCached : () ->
      @data == null

    _getCachedData : () ->
      # TODO add local storage cache
      deferred = $q.defer()
      deferred.resolve(@data)
      @_resolveDelayedPromise()
      return deferred.promise

    _getFreshData : () ->
      promise = @Model[@getter].apply(@Model, @getterArgs)
      promise.then (data) =>
        @data = data
        @_resolveDelayedPromise()
      return promise

    _addFreshData : (getterArgs) ->
      promise = @Model[@getter].apply(@Model, getterArgs)
      promise.then (data) =>
        @data = data
        @_resolveDelayedPromise()
      return promise

    _getDelayedData : () ->
      @delayedPromise ||= $q.defer()
      return @delayedPromise.promise

    _resolveDelayedPromise : () ->
      @inProggress = false
      if @delayedPromise
        @delayedPromise.resolve(@data)
        @delayedPromise = null

]
