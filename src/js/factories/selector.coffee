app.factory 'Selector', [ () ->

  class Selector

    constructor : (values, selected) ->
      @isOpen = no
      @values = values || []
      @selected = selected || null

    setSelected : (selected) ->
      @selected = selected

    setValues : (values) ->
      @values = values

    getSelected : ->
      @selected

    getValues : ->
      @values

    close : ->
      @isOpen = no

    open : ->
      @isOpen = yes

    toggle : ->
      @isOpen = !@isOpen

    isOpen : ->
      @isOpen

    getSelectedName : ->
      if _.isObject(@selected) then @selected.name else null

]
