app.service 'DateService', [ () ->

  SIMPLE_KEY = 'simple'

  MONTHS = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ]

  format : (date, type) ->
    if type is SIMPLE_KEY
      minutes = date.getMinutes()
      if minutes < 10
        minutes = '0' + minutes
      [date.getHours(), minutes].join(':')
    else
      [date.getDate(), MONTHS[date.getMonth()], date.getFullYear()].join(' ')

]
