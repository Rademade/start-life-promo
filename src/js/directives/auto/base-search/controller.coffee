app.controller 'autoBaseSearchController', [ '$scope', ($scope) ->

  @factory = $scope.factory

  @updateCarModel = (car) ->
    car.isModelDisabled = no
    @factory.setCar car.make.getSelected()
    car.model.setValues @factory.getModels()
    car.model.setSelected()

  return

]
