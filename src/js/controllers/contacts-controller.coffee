app.controller 'contactsController', [
  'synchronization', 'User', '$state',
  (synchronization, User, $state) ->

    ENTER_CODE = 13

    @isFormSubmitted = no

    window.addEventListener 'keyup', (event) ->
      $state.go 'public.contacts' if event.keyCode is ENTER_CODE

    @hasError = (field, error) ->
      @isFormSubmitted && field.$error[error]

    @clearLetterFields = ->
      @letter.theme = ''
      @letter.text = ''

    @submit = (isValid) ->
      @isFormSubmitted = yes
      if isValid
        params = _.merge @letter, id : synchronization.getUserId()
        User.letter(params).then (data) =>
          @clearLetterFields()
          $state.go 'public.contacts.popup' unless data.error

    return

]
