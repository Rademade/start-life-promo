app.controller 'homeAdvancedSearchController', [ '$scope', ($scope) ->

  @selectors = $scope.selectors

  @toggle = ->
    @selectors.openHouses = !@selectors.openHouses

  @isHouseSizeError = ->
    minSize = @selectors.minHouseSize.getSelected()?.value
    maxSize = @selectors.maxHouseSize.getSelected()?.value
    @selectors.isFormSubmitted && minSize > maxSize

  @isLotSizeError = ->
    minSize = @selectors.minLotSize.getSelected()?.value
    maxSize = @selectors.maxLotSize.getSelected()?.value
    @selectors.isFormSubmitted && minSize > maxSize

  @isYearError = ->
    minYear = @selectors.minYearBuild.getSelected()?.name
    maxYear = @selectors.maxYearBuild.getSelected()?.name
    @selectors.isFormSubmitted && minYear > maxYear

  return

]
