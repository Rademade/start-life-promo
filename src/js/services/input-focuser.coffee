app.service 'inputFocuser', [ () ->

  focus : (params) ->
    e = params.element.querySelectorAll('input.form-input')[params.index]
    e.focus()

  blur : (params) ->
    e = params.element.querySelectorAll('input.form-input')[params.index]
    e.blur()

]
