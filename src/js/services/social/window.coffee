class @SocialWindow

  $window : undefined

  open : (url) ->
    if typeof @$window isnt 'object' or @$window.closed
      config = 'toolbar=0,status=0,width=1024,height=720,left=100,top=100,screenX=100,screenY=100'
      @$window = window.open(url, 'StartLife', config)
    else
      @$window.focus()

  success : (account) ->
    event = new CustomEvent 'socialSuccess',
      detail : account
    @getParent().document.dispatchEvent event

  error : (errorText) ->
    event = new CustomEvent 'socialFail',
      detail : errorText.substr(0, 100)
    @getParent().document.dispatchEvent event

  getParent : () ->
    if window.opener
      if navigator.appVersion.indexOf('MSIE') is -1
        window.opener.parent
      else
        window.opener
    else
      window

  close : () ->
    if window.opener
      window.close()
    else
      window.location.href = '/'

@SocialWindow.open = (provider) ->
  socialWindow = new SocialWindow()
  socialWindow.open '/* @echo socialPrefix */' + "auth/#{provider}"
  socialWindow

@SocialWindow.success = (account) ->
  socialWindow = new SocialWindow()
  socialWindow.success account
  socialWindow.close()
  socialWindow

@SocialWindow.error = (errorText) ->
  socialWindow = new SocialWindow()
  socialWindow.error errorText
  socialWindow.close()
  socialWindow
