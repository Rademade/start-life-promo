angular.module('appResource', ['rails']).factory 'StartLifeResource', [
  'RailsResource'
  (RailsResource) ->

    class StartLifeResource extends RailsResource

    StartLifeResource.resourceUrl = (previous) ->
      '/* @echo apiPrefix */' + RailsResource.resourceUrl.apply this, arguments

    StartLifeResource

]
