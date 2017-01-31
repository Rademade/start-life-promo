app.controller 'logRegController', [ 'User', 'synchronization', '$state', (User, synchronization, $state) ->

  @isFormSubmitted = no
  @error = ''

  @clearError = ->
    @error = ''

  @clearConfirmationEmail = () ->
    @confirmationEmail = ''

  @resetEmail = (isValid) ->
    $state.go 'index.log-reg' unless isValid

    User.recovery(email : @confirmationEmail).then (data) =>
      if data?.error
        @error = data.error
      else
        $state.go 'index.log-reg.popup-email-check'

  @hasError = (field, error) ->
    @isFormSubmitted && field.$error[error]

  @isEmailError = (form) ->
    @isFormSubmitted && !form.confirmationEmail.$valid

  return

]
