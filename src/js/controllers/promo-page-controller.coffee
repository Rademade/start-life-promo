app.controller 'promoPageController', [
  '$scope', '$interval', 'youtubeEmbedUtils', 'browser', 'linkOpener'
  ($scope, $interval, youtubeEmbedUtils, browser, linkOpener) ->

    LINK_CHROME_DOWNLOAD = 'https://www.google.com/chrome/browser/desktop/'
    LINK_CHROME_EXTENSION = 'https://chrome.google.com/webstore/detail/live-start-page-living-wa/ocggccaacacpienfcgmgcihoombokbbj'
    LINK_YOUTUBE_VIDEO = 'http://www.youtube.com/watch?v=2Rxoz13Bthc'

    @videoId = youtubeEmbedUtils.getIdFromURL(LINK_YOUTUBE_VIDEO)

    @secondsToStart = 3
    @isVideoShowed = no
    @isTimerWasted = no
    @timer = no
    @player = null

    @startTimer = ->
      unless @isTimerWasted
        @timer = $interval( =>
          if @secondsToStart > 1
            @secondsToStart -= 1
          else
            $interval.cancel @timer
            @timer = no
            @isVideoShowed = yes
            @player.playVideo() if @player
        , 1000)
      @isTimerWasted = yes

    @showVideo = ->
      if @isTimerWasted
        @isVideoShowed = yes
        @player.playVideo() if @player
      else
        @startTimer()

    @hideVideo = ->
      @isVideoShowed = no
      @player.stopVideo() if @player

    @timerText = ->
      if @timer then @secondsToStart else 'play'

    $scope.$on 'youtube.player.ready', ($event, player) =>
      @player = player if player.id is 'promoVideo'

    @isChoromeAvailable = ->
      browser.isChromeAvailable()

    @downloadChrome = ->
      linkOpener.open(LINK_CHROME_DOWNLOAD)

    @addExtension = ->
      linkOpener.open(LINK_CHROME_EXTENSION)

    @startTimer()

    return

]
