app.controller 'headerController', [
  'headerTabService', 'synchronization', '$scope', '$rootScope', '$state',
  (headerTabService, synchronization, $scope, $rootScope, $state) ->

    @headerTabService = headerTabService

    @init = ->
      @tabs = headerTabService.getTabs()
      @settingsUpdated = synchronization.getUser().settings.updated

    @config =
      onSort : (e) ->
        synchronization.setHeaderTabs(e.models)

    @profileText = ->
      if @settingsUpdated
        'Save settings'
      else
        'Profile'

    @isActiveState = () ->
      $state.is('index.log-reg') or $state.includes('public.profile')

    $scope.sync.onSync () =>
      @init()

    $rootScope.$on '$stateChangeSuccess', (event, toState, toParams, fromState, fromParams) =>
      headerTabService.setFirstTabActive(@tabs)

    @init()

    return

]
