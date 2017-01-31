app.filter 'regex', [ () ->
  (objects, field, regex) ->
    pattern = new RegExp(regex)

    _.filter objects, (object) ->
      pattern.test object[field]
]
