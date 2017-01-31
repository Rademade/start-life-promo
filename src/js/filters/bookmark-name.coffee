app.filter 'bookmarkName', [ 'bookmarkService', (bookmarkService) ->
  (rawName) ->
    bookmarkService.formatBookmarkName(rawName) if rawName

]
