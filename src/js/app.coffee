window.app = angular.module('app', [
  'ui.router',
  'ngStorage',
  'ng-sortable',
  'ng.deviceDetector',
  'ngSanitize',
  'ngCookies',
  'angucomplete-alt',
  'ngAutocomplete',
  'youtube-embed',
  'xml',
  'appResource'
]).run([
  '$rootScope', '$templateFactory', '$templateCache','$stateParams','$state', '$http',
  ($rootScope, $templateFactory, $templateCache, $stateParams, $state, $http) ->

    $templateFactory.fromString = (name) -> Templates[name]

    window.isRequestPending =  -> $http.pendingRequests.length != 0

    $rootScope.options = window.options

    for own templateName, templateSource of Templates
      $templateCache.put templateName, templateSource

    $rootScope.safeApply = (change) ->
      if $rootScope.$$phase then change() else $rootScope.$apply change

    $rootScope.$state = $state
    $rootScope.$stateParams = $stateParams
])
