app.filter 'dateFormat', ['DateService', (DateService) ->
  (rawDate, type) ->
    DateService.format(new Date(rawDate), type) if rawDate

]
