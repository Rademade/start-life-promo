app.controller 'delConfirmationController', [
  '$state', 'User', 'synchronization',
  ($state, User, synchronization) ->

    User.deletion($state.params.key).then (data) =>
      synchronization.reset() unless data?.error
      $state.go 'index.log-reg.popup-afterdelete'

    return

]
