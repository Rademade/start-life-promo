app.service 'gmail', [ '$rootScope', 'synchronization', ($rootScope, synchronization) ->

  CLIENT_ID = '884226483180-1rop067ieqdu34ejqnqdriiuqntfjr2i.apps.googleusercontent.com'
  SCOPES = ['https://www.googleapis.com/auth/gmail.readonly']

  messagesUnread = 0

  init = (immediate) ->
    gapi.auth.authorize({
      client_id : CLIENT_ID,
      scope : SCOPES.join(' '),
      immediate : immediate
    }, loadMessages)

  loadMessages = ->
    googleId = synchronization.getGoogleId()
    if googleId
      gapi.client.load 'gmail', 'v1', () =>
        request = gapi.client.gmail.users.labels.get
          userId : googleId
          id : 'CATEGORY_PERSONAL'

        request.execute (resp) =>
          $rootScope.$apply () ->
            messagesUnread = resp.messagesUnread if resp.messagesUnread

  loadMessages : loadMessages

  init : ->
    try
      init(yes)
    catch
      init(no)

  getMessagesUnread : ->
    messagesUnread

  isNotLogined : ->
    googleId = synchronization.getGoogleId()
    if _.isString(googleId) && googleId.length > 0 then no else yes

]
