app.controller 'registrationController', [ 'User', '$state', 'synchronization', '$scope', (User, $state, synchronization, $scope) ->

  @isSuccessSubmitted = no
  @isSubmitted = no
  @error = ''

  @clearError = ->
    @error = ''
    @isSubmitted = no

  @submit = (isValid) ->
    @isSubmitted = yes

    if isValid && @isMatchPassword()
      new User(@user).create().then (data) =>
        if data?.error
          @error = data.error
        else
          @isSuccessSubmitted = yes
          $state.go 'index.log-reg.popup-email'

  @hasError = (field, error) ->
    @isSubmitted && field.$error[error]

  @isMatchPassword = ->
    @user and @user.password is @user.repeatPassword

  @init = ->
    userId = synchronization.getUserId()
    $state.go 'public.profile.edit' if _.isString(userId) && userId.length > 20

  @init()

  return

]
