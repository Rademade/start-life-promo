app.factory 'Datepicker', [ () ->

  class Datepicker

    MONTHS_SHOWED = 2
    MONTHS_COUNT = 12
    DAYS_SHOWED = 42
    DAYS_MAX = 330
    MONTHS_MAX = Math.ceil(DAYS_MAX / 30.0) + 1

    FEBRUARY = 'February'

    CSS_CLASS_LEFT = 'mod-left'
    CSS_CLASS_RIGHT = 'mod-right'
    CSS_CLASS_CURRENT = 'is-current'
    CSS_CLASS_ERROR = 'is-error'
    CSS_CLASS_DISABLED = 'is-disabled'

    DAYS = [
      { name : 'S' },
      { name : 'M' },
      { name : 'T' },
      { name : 'W' },
      { name : 'T' },
      { name : 'F' },
      { name : 'S' }
    ]

    MONTHS = [
      { name : 'January',   days : 31 },
      { name : 'February',  days : 28 },
      { name : 'March',     days : 31 },
      { name : 'April',     days : 30 },
      { name : 'May',       days : 31 },
      { name : 'June',      days : 30 },
      { name : 'July',      days : 31 },
      { name : 'August',    days : 31 },
      { name : 'September', days : 30 },
      { name : 'October',   days : 31 },
      { name : 'November',  days : 30 },
      { name : 'December',  days : 31 }
    ]

    OPTIONS = [
      { name : 'Exact dates' }
      { name : '1 day before' },
      { name : '1 day after' },
      { name : '+/­- 1 day' },
      { name : '+/­- 2 days' },
      { name : '+/­- 3 days' }
    ]

    constructor : (modeRight = no) ->
      @currentIndex = 0
      @isOpen = no
      @months = @getMonths()
      @date = undefined
      @modeRight = modeRight

    open : ->
      @reload()
      @isOpen = yes

    close : ->
      @isOpen = no

    toggle : ->
      @reload()
      @isOpen = !@isOpen

    getIsOpen : ->
      @isOpen

    getOptions : ->
      OPTIONS

    getDays : ->
      DAYS

    prev : ->
      if @prevAvailable()
        @currentIndex -= 1

    next : ->
      if @nextAvailable()
        @currentIndex += 1

    prevAvailable : ->
      @currentIndex - 1 >= 0

    nextAvailable : ->
      @currentIndex + MONTHS_SHOWED < MONTHS_COUNT

    setDate : (date) ->
      @date = date
      @reset()
      @setActiveDay(date)

    setInterval : (dateFrom, dateTo) ->
      @reset()
      @setActiveDay(dateFrom)
      @setActiveDay(dateTo)

      _.each @months, (month) ->
        _.each month.days, (day) =>
          date = new Date(month.year, month.index, day.name)
          day.during = dateFrom < date && date < dateTo
          yes
        yes

    turnOffInterval : (dateFrom, dateTo) ->
      _.each @months, (month) ->
        _.each month.days, (day) ->
          date = new Date(month.year, month.index, day.name)
          day.disabled = dateFrom < date and date < dateTo
          yes
        yes

    setActiveDay : (date) ->
      if date
        year = date.getFullYear()
        index = date.getMonth()
        date = date.getDate()
        _.each @months, (month) ->
          _.each month.days, (day) =>
            day.active = yes if month.year is year && month.index is index && day.name is date
            yes
          yes

    reset : () ->
      _.each @months, (month) ->
        _.each month.days, (day) =>
          day.active = no
          day.during = no
          yes
        yes

    reload : () ->
      if @date
        _.each @months, (month, index) =>
          if month.index is (new Date(@date)).getMonth()
            @currentIndex = index
          yes

    getDate : () ->
      @date

    getFormatedDate : () ->
      if @date
        day = @date.getDate()
        day = if day < 10 then "0#{day}" else day
        month = @date.getMonth() + 1
        month = if month < 10 then "0#{month}" else month
        [month, day, @date.getFullYear()].join('/')
      else
        ''

    getShowedMonths : ->
      if @months.length < MONTHS_SHOWED
        @months
      else
        @months.slice(@currentIndex, @currentIndex + MONTHS_SHOWED)

    getMonths : ->
      today = new Date()
      year = today.getFullYear()
      from = today.getMonth()
      to = from + MONTHS_COUNT
      index = from
      months = []
      loop
        if index > MONTHS_MAX - 1
          index = 0
          year += 1
        month = MONTHS[index]
        days = if @isLeapMonth(year, month.name) then month.days + 1 else month.days
        months.push { index : index, name : month.name, year : year, days : @getMonthDays(year, index, days) }
        from += 1
        index += 1
        break if from > to - 1
      @disableDays(months)

    disableDays : (months) ->
      count = 0
      _.each months, (month) ->
        _.each month.days, (day) ->
          if day.disabled is no && count <= DAYS_MAX
            count += 1
          else
            day.disabled = yes
          yes
        yes
      months

    isNotSelectedDate : () ->
      _.isUndefined(@date)

    setRightMode : (key) ->
      @modeRight = key

    getMonthDays : (year, month, days) ->
      days = [1..days]
      firstDayOfMonth = new Date(year, month, 1)
      n = firstDayOfMonth.getDay()

      if n isnt 7 && n isnt 6
        days = _.concat(Array(n).fill(''), days)

      if DAYS_SHOWED - days.length > 0
        days = _.concat(days, Array(DAYS_SHOWED - days.length).fill(''))

      _.map days, (day) =>
        name : day
        active : no
        disabled : new Date(year, month, day) < @getYesterday() || _.isString(day)
        during : no

    getYesterday : ->
      date = new Date()
      date.setDate(date.getDate() - 1)

    isLeapMonth : (year, month) ->
      ((year % 4 is 0 && year % 100 isnt 0) || (year % 400 is 0)) && month is FEBRUARY

    getClass : (isSubmitted, isDisabled = no) ->
      css = []
      if isDisabled
        css.push CSS_CLASS_DISABLED
      else
        css.push if @modeRight then CSS_CLASS_RIGHT else CSS_CLASS_LEFT
        if @isOpen
          css.push CSS_CLASS_CURRENT
        else if !@date && isSubmitted
          css.push CSS_CLASS_ERROR
      css.join(' ')

]
