app.directive 'clickPreventer', ->
  restrict : 'A'
  link : ($scope, $el, attrs) ->
    action = attrs.clickPreventer || 'all'
    $el.bind 'click', (event) ->
      event.stopPropagation()
      event.preventDefault() if action is 'all'
