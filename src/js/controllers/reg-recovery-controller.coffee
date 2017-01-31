app.controller 'regRecoveryController', [
  '$state', 'User', 'synchronization',
  ($state, User, synchronization) ->

    User.recovery($state.params.key).then (data) ->
      console.log 'data.type: ', data
      if data?.error
        $state.go 'index.log-reg'
      else
        synchronization.setPopups(data.type) if data.type?
        synchronization.setUserId(data.userId)
        $state.go 'public.profile.edit'

    return

]
