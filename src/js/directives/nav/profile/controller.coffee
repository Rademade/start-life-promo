app.controller 'navProfileController', [ 'synchronization', (synchronization) ->

  loggedIn = !(synchronization.getUser().id is "")
  if loggedIn then profileRef = 'public.profile.edit' else profileRef = 'index.log-reg'

  @tabs = [
    sref : profileRef
    name : 'Profile'
    class : 'mod-profile'
  ,
    sref : 'public.contacts'
    name : 'Contacts'
    class : 'mod-contacts'
  ]

  return

]
