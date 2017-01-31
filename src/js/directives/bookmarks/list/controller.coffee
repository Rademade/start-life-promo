app.controller 'bookmarksController', [
  'bookmarkService', 'linkOpener', 'synchronization', '$scope', 'gmail', '$timeout',
  (bookmarkService, linkOpener, synchronization, $scope, gmail, $timeout) ->

    ESC_KEY_CODE = 27

    @service = gmail
    @bookmarks = []

    window.addEventListener 'keyup', (event) =>
      if event.keyCode is ESC_KEY_CODE
        bookmarkService.cancelEditing()

    @editBookmark = (bookmark) ->
      bookmarkService.setBookmarkForEditing(bookmark)

    @isEditing = (bookmark) ->
      bookmarkService.isEditingBookmark(bookmark)

    @getCssClasses = (bookmark) ->
      bookmarkService.getCssClasses(bookmark)

    @loadBookmarks = () ->
      @bookmarks = []
      bookmarkService.getBookmarks().then (bookmarks) =>
        @bookmarks = bookmarks

    @config =
      onSort : (e) ->
        synchronization.setBookmarks(e.models)

    @openLink = (link) ->
      linkOpener.openHere(link)

    $scope.sync.onSync () =>
      @loadBookmarks()

    @loadBookmarks()

    return

]
