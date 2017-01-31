app.filter 'to_trusted', [ '$sce', ($sce) ->
  (text) ->
    $sce.trustAsHtml text

]
