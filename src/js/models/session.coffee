app.factory 'Session', [ 'StartLifeResource', (StartLifeResource) ->

  class Session extends StartLifeResource
    @configure url : '/sessions', name : 'sessions'

]
