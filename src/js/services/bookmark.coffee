app.service 'bookmarkService', [
  'Bookmark', 'BookmarkCategory', '$localStorage', '$q', '$rootScope',
  (Bookmark, BookmarkCategory, $localStorage, $q, $rootScope) ->

    DEFAULT_PREFIX = 'https://www.'
    CSS_CLASS_IS_SETTINGS = 'is-settings'

    MAX_BOOKMARK_NAME_LENGTH = 10
    BOOKMARK_CATEGORIES_KEY = 'bookmarkCategories'
    BOOKMARKS_KEY = 'bookmarks'

    isBookmarksConfigured = $localStorage[BOOKMARKS_KEY + 'Configured'] || no
    isBookmarkCategoriesConfigured = $localStorage[BOOKMARK_CATEGORIES_KEY + 'Configured'] || no

    bookmarksPromise = $q.defer()
    bookmarkCategoriesPromise = $q.defer()

    currentBookmark = {}

    configureBookmarkCategories : ->
      BookmarkCategory.getAll().then (categories) ->
        $localStorage[BOOKMARK_CATEGORIES_KEY + 'Configured'] = yes
        $localStorage[BOOKMARK_CATEGORIES_KEY] = categories
        bookmarkCategoriesPromise.resolve($localStorage[BOOKMARK_CATEGORIES_KEY])

    configureBookmarks : ->
      Bookmark.getAll().then (bookmarks) =>
        $localStorage[BOOKMARKS_KEY + 'Configured'] = yes
        isBookmarksConfigured = yes
        $localStorage[BOOKMARKS_KEY] = @serialize(bookmarks)
        bookmarksPromise.resolve($localStorage[BOOKMARKS_KEY])

    getCategories : ->
      if isBookmarkCategoriesConfigured
        bookmarkCategoriesPromise.resolve($localStorage[BOOKMARK_CATEGORIES_KEY])
      else
        @configureBookmarkCategories()
      bookmarkCategoriesPromise.promise

    getCategory : (name) ->
      bookmarkCategoriesPromise = $q.defer()
      @getCategories().then (categories) ->
        category = _.find(categories, (category) => category.name is name)
        bookmarkCategoriesPromise.resolve(category)
      bookmarkCategoriesPromise.promise

    getBookmarks : ->
      bookmarksPromise = $q.defer()
      if isBookmarksConfigured
        bookmarksPromise.resolve($localStorage[BOOKMARKS_KEY])
      else
        @configureBookmarks()
      bookmarksPromise.promise

    setBookmarks : (bookmarks = []) ->
      if bookmarks.length
        $localStorage[BOOKMARKS_KEY] = bookmarks
        isBookmarksConfigured = yes

    serialize : (bookmarks) ->
      _.each bookmarks, (bookmark) =>
        @getCategory(bookmark.category.name).then (category) ->
          bookmark.category = category
        yes

    saveEditedBookmark : () ->
      isSaved = no
      if @isValid(currentBookmark)
        bookmarks = $localStorage[BOOKMARKS_KEY]
        $localStorage[BOOKMARKS_KEY] = _.map bookmarks, (bookmark) =>
          if bookmark.id is currentBookmark.id
            bookmark = currentBookmark
          @permitParams(bookmark)
        currentBookmark = {}
        isSaved = yes
      isSaved

    permitParams : (bookmark) ->
      id : bookmark.id
      name : bookmark.name
      link : bookmark.link
      notifications : bookmark.notifications
      category :
        id : bookmark.category.id
        name : bookmark.category.name
        link : bookmark.category.link
        classCss : bookmark.category.classCss

    isValid : (bookmark) ->
      bookmark.name && bookmark.link && bookmark.category

    formatBookmarkName : (name) ->
      len = name.length

      if len >= MAX_BOOKMARK_NAME_LENGTH
        name = name.substring(0, 10)

        if len >= MAX_BOOKMARK_NAME_LENGTH
          [name, '..'].join('')
        else
          name


      else
        name

    setBookmarkForEditing : (bookmark) ->
      currentBookmark = _.cloneDeep bookmark

    cancelEditing : () ->
      $rootScope.safeApply () ->
        currentBookmark = {}

    getBookmarkForEditing : () ->
      currentBookmark

    isEditingBookmark : (bookmark) ->
      if _.isEmpty(currentBookmark) then no else currentBookmark.id is bookmark.id

    getCssClasses : (bookmark) ->
      cssClasses = []
      if @isEditingBookmark(bookmark)
        cssClasses.push CSS_CLASS_IS_SETTINGS
        bookmark = currentBookmark
      cssClasses.push bookmark.category.classCss
      cssClasses.join(' ')

    updateBookmarkField : (field, value) ->
      currentBookmark[field] = value

    isGmailBookmark : (bookmark) ->
      bookmark.category.name is 'Email'

    isGmailEmail : () ->
      email_re = /^[_a-z0-9]+(\.[_a-z0-9]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/
      gmail_re = /(mail\.google|gmail)/
      gmail_re.test(currentBookmark.link) || email_re.test(currentBookmark.name)

    isGmail : (bookmark) ->
      @isGmailBookmark(bookmark) && @isGmailEmail()

    checkLink : () ->
      link = currentBookmark.link
      if link.length > DEFAULT_PREFIX.length - 1
        domain = link.match(/^(?:https?:\/\/)?(?:www.)?(.*)$/)[1]
        @updateBookmarkField('name', @getNameFromDomain(domain))

    getNameFromDomain : (domain) ->
      if domain then _.capitalize domain.split('.')[0] else ''

    updateNotifications : (messagesUnread) ->
      @getBookmarks().then (bookmarks) =>
        _.each bookmarks, (bookmark) =>
          if @isGmailBookmark(bookmark)
            bookmark.notifications = messagesUnread
          yes

    moveFromTo : (source, dest) ->
      @getBookmarks().then (data) =>
        bookmarks = data
        bookmark = bookmarks.splice(source, 1)[0]
        bookmarks.splice dest, 0, bookmark
        $localStorage[BOOKMARKS_KEY] = bookmarks

]
