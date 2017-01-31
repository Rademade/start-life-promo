app.controller 'changePasswordController', [
  '$state', 'User', 'synchronization',
  ($state, User, synchronization) ->

    User.change_password_for($state.params.key).then (data) ->

      if data?.error
        $state.go 'index.log-reg'
      else
        synchronization.setUserId(data.userId)
        synchronization.loadSettings().then () ->
          $state.go 'public.profile.edit.change-password'

    return

]
