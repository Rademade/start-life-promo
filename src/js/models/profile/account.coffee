app.factory 'Account', [ 'StartLifeResource', (StartLifeResource) ->

  class Account extends StartLifeResource
    @configure url : '/accounts', name : 'accounts'

]
