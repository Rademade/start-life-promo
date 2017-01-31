app.directive 'focus', ($timeout) ->
  restrict : 'A'
  link : (scope, element) ->
    $timeout( () ->
      element[0].focus()
    , 0)
