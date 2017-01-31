app.factory 'User', [ 'StartLifeResource', (StartLifeResource) ->

  class User extends StartLifeResource
    @configure url : '/users', name : 'users'

    @letter : (params) ->
      @$post @resourceUrl('letter'), params

    @recovery : (params) ->
      @$post @resourceUrl('recovery'), params

    @registration : (key) ->
      @$post @resourceUrl('registration'), key : key

    @deletion : (key) ->
      @$post @resourceUrl('deletion'), key : key

    @change_password_for : (key) ->
      @$post @resourceUrl('change_password_for'), key : key

    @change_password : (params) ->
      @$post @resourceUrl('change_password'), params

    @deletion_confirmation : (params) ->
      @$post @resourceUrl('deletion_confirmation'), params

]
