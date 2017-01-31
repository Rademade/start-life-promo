app.controller 'regConfirmationController', [
  '$state', 'User', 'synchronization',
  ($state, User, synchronization) ->

    User.registration($state.params.key).then (data) =>
      if data?.error
        $state.go 'index.log-reg'
      else
        synchronization.setUserId(data.userId)
        $state.go 'public.profile.edit.reg-popup'

    return

]
