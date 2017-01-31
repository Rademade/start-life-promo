app.controller 'bookmarkFormController', [
  '$scope', 'bookmarkService', 'Selector', 'synchronization',
  ($scope, bookmarkService, Selector, synchronization) ->

    @isBookmarkFormSubmitted = no

    @loadBookmark = () ->
      @editingBookmark = _.cloneDeep bookmarkService.getBookmarkForEditing()

    bookmarkService.getCategories().then (categories) =>
      category = _.find(categories, (category) => category.id is @editingBookmark.category.id)
      @selector = new Selector(categories, category)

    @cancelEditing = ->
      bookmarkService.cancelEditing()

    @onCategoryChangeCb = () ->
      bookmarkService.updateBookmarkField('category', @selector.getSelected())
      bookmarkService.updateBookmarkField('link', '')
      bookmarkService.updateBookmarkField('name', '')
      @editingBookmark.link = ''
      @editingBookmark.name = ''

    @onLinkChangeCb = () ->
      bookmarkService.updateBookmarkField('link', @editingBookmark.link)
      bookmarkService.checkLink()
      @loadBookmark()

    @onNameChangeCb = () ->
      bookmarkService.updateBookmarkField('name', @editingBookmark.name)

    @saveBookmark = ->
      @isBookmarkFormSubmitted = yes
      if bookmarkService.saveEditedBookmark()
        @sync()
        $scope.onSaveCb()

    @sync = ->
      bookmarkService.getBookmarks().then (bookmarks) =>
        if bookmarks && bookmarks[0]?.category
          synchronization.setBookmarks(bookmarks)

    @showLogin = (bookmark) ->
      bookmarkService.isGmail(bookmark) && @isGmailNotLogined()

    @updateNotifications = (messagesUnread) ->
      bookmarkService.updateNotifications(messagesUnread)

    @isGmailNotLogined = () ->
      $scope.service.isNotLogined()

    @authenticate = (url) ->
      SocialWindow.open(url)

    @login = (userId) ->
      synchronization.setUserId(userId)
      synchronization.loadSettings().then () ->
        $state.go 'public.profile.edit'

    @isFieldError = (field) ->
      !Boolean(field) && @isBookmarkFormSubmitted

    window.addEventListener 'message', (event) =>
      for key, key_args of event.data
        switch key
          when 'userId' then  @login(key_args); break

    $scope.$watch () ->
      $scope.service.getMessagesUnread()
    , =>
      @updateNotifications($scope.service.getMessagesUnread())

    @loadBookmark()

    return

]
