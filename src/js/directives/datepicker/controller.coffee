app.controller 'datepickerController', [ '$scope', '$timeout', ($scope, $timeout) ->

  @datepicker = $scope.service
  @placeholder = $scope.placeholder || 'Depart'
  @months = []
  @days = @datepicker.getDays()

  @toggle = ->
    @datepicker.toggle()
    $scope.onToggleCb(datepicker : @datepicker)

  $scope.$watch 'focus', =>
    if $scope.focus
      # TODO use scope digest
      $timeout () =>
        @toggle()

  @close = ->
    @datepicker.close()

  @getArrrowClass = (index) ->
    if index is 0
      if @datepicker.prevAvailable()
        'mod-prev'
    else if index is @months.length - 1
      if @datepicker.nextAvailable()
        'mod-next'

  @getDayClass = (day) ->
    if day.active
      'is-active'
    else if day.disabled
      'is-disabled'
    else if day.during
      'is-during'
    else
      ''

  @getTitle = (month) ->
    "#{month.name} #{month.year}"

  @setDate = (month, day) ->
    date = new Date(month.year, month.index, day.name)
    @datepicker.setDate(date)
    @reloadMonths()
    @close()
    $scope.onSelectCb()

  @getDate = ->
    date = @datepicker.getFormatedDate()
    date || @placeholder

  @update = (index) ->
    if index is 0
      @datepicker.prev()
    else if index is @months.length - 1
      @datepicker.next()
    @reloadMonths()

  @reloadMonths = ->
    @months = @datepicker.getShowedMonths()

  @reloadMonths()

  return

]
