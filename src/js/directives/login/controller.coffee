app.controller 'loginController', [
  'Session', '$state', 'synchronization', '$scope',
  (Session, $state, synchronization, $scope) ->

    @isSubmitted = no
    @error = ''

    @clearError = ->
      @error = ''
      @isSubmitted = no

    @submit = (isValid) ->
      @isSubmitted = yes

      if isValid
        new Session(@user).create().then (data) =>
          if data?.error
            @error = data.error
          else
            @login(data.userId)

    @hasError = (field, error) ->
      @isSubmitted && field.$error[error]

    @authenticate = (url) ->
      SocialWindow.open(url)

    @login = (userId, firstLogin = no) ->
      synchronization.setUserId(userId)
      synchronization.loadSettings().then () =>
        if firstLogin then $state.go 'public.profile.edit.reg-popup' else $state.go 'public.profile.edit'

    @forgot = () ->
      $state.go 'index.log-reg.popup-email-input'

    window.addEventListener 'message', (event) =>
      for key, key_args of event.data
        switch key
          when 'userId'
            @login(key_args, event.data.firstLogin)
            break

    return

]
