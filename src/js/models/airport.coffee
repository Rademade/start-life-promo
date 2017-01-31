app.factory 'Airport', [ 'StartLifeResource', (StartLifeResource) ->

  class Airport extends StartLifeResource
    @configure url : '/airports', name : 'airports'

    @getAutocomplete : (params) ->
      @get params
]
