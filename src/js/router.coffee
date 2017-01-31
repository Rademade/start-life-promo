app.config [
  '$stateProvider', '$urlRouterProvider', '$locationProvider'
  ($stateProvider, $urlRouterProvider, $locationProvider) ->

    $stateProvider

      .state 'index',
        abstract : true
        url : '/'
        templateUrl : 'layout/promo'

      .state 'index.home',
        url : ''
        controller : 'promoPageController'
        controllerAs : 'promoPageCtrl'
        templateUrl : 'views/start'

      # .state 'promo',
      #   abstract : true
      #   url : '/promo/'
      #   templateUrl : 'layout/promo'

      # .state 'promo.start',
      #   url : 'start'
      #   controller : 'promoPageController'
      #   controllerAs : 'promoPageCtrl'
      #   templateUrl : 'views/start'

      # .state 'index',
      #   abstract : true
      #   url : '/'
      #   templateUrl : 'layout/index'

      # .state 'index.home',
      #   url : ''
      #   templateUrl : 'views/index'

      # .state 'index.log-reg',
      #   url : 'log-reg'
      #   controller : 'logRegController'
      #   controllerAs : 'logRegCtrl'
      #   templateUrl : 'views/log-reg'

      # .state 'index.log-reg.popup-afterdelete',
      #   url : '/popups/after-profile-delete'
      #   controller : 'logRegController'
      #   controllerAs : 'logRegCtrl'
      #   templateUrl : 'views/log-reg'

      # .state 'index.log-reg.popup-email',
      #   url : '/popups/check-email'
      #   controller : 'logRegController'
      #   controllerAs : 'logRegCtrl'
      #   templateUrl : 'views/log-reg'

      # .state 'index.log-reg.popup-email-input',
      #   url : '/popups/password-recovery'
      #   controller : 'logRegController'
      #   controllerAs : 'logRegCtrl'
      #   templateUrl : 'views/log-reg'

      # .state 'index.log-reg.popup-email-check',
      #   url : '/popups/check-email-recovery'
      #   controller : 'logRegController'
      #   controllerAs : 'logRegCtrl'
      #   templateUrl : 'views/log-reg'

      # .state 'public',
      #   abstract : true
      #   url : '/'
      #   templateUrl : 'layout/main'

      # .state 'public.news',
      #   url : 'news'
      #   templateUrl : 'views/news'

      # .state 'public.news.show',
      #   url : '/:site_id'
      #   templateUrl : 'views/news'

      # .state 'public.multi-search',
      #   abstract: true
      #   url : 'multi-search/'
      #   templateUrl : 'views/multi-search'

      # .state 'public.multi-search.travel',
      #   url : 'travel'
      #   templateUrl : 'views/multi-search/travel'

      # .state 'public.multi-search.auto',
      #   url : 'auto'
      #   templateUrl : 'views/multi-search/auto'
      #   controller : 'autoSearchController'
      #   controllerAs : 'autoSearchCtrl'

      # .state 'public.multi-search.homes',
      #   url : 'homes'
      #   templateUrl : 'views/multi-search/homes'
      #   controller : 'homeSearchController'
      #   controllerAs : 'homeSearchCtrl'

      # .state 'public.reg-confirmation',
      #   url : 'public/registration/:key'
      #   controller : 'regConfirmationController'

      # .state 'public.reg-recovery',
      #   url : 'public/recovery/:key'
      #   controller : 'regRecoveryController'

      # .state 'public.change-password',
      #   url : 'public/change_password/:key'
      #   controller : 'changePasswordController'

      # .state 'public.del-confirmation',
      #   url : 'public/deletion/:key'
      #   controller : 'delConfirmationController'

      # .state 'public.profile',
      #   abstract : true
      #   url : 'profile/'
      #   templateUrl: 'layout/ui-view'

      # .state 'public.profile.edit',
      #   url : 'edit'
      #   controller : 'profileController'
      #   controllerAs : 'profileCtrl'
      #   templateUrl : 'views/profile-edit'
      #   parent : 'public.profile'

      # .state 'public.profile.edit.delete-profile',
      #   url : 'edit/popups/delete-profile'
      #   controller : 'profileController'
      #   controllerAs : 'profileCtrl'
      #   templateUrl : 'views/profile-edit'
      #   parent : 'public.profile'

      # .state 'public.profile.edit.delete-popup-check',
      #   url : 'edit/popups/delete-popup'
      #   controller : 'profileController'
      #   controllerAs : 'profileCtrl'
      #   templateUrl : 'views/profile-edit'
      #   parent : 'public.profile'

      # .state 'public.profile.edit.change-password',
      #   url : 'edit/popups/change-password'
      #   controller : 'profileController'
      #   controllerAs : 'profileCtrl'
      #   templateUrl : 'views/profile-edit'
      #   parent : 'public.profile'

      # .state 'public.profile.edit.successfully-changed',
      #   url : 'edit/popups/successfully-changed'
      #   controller : 'profileController'
      #   controllerAs : 'profileCtrl'
      #   templateUrl : 'views/profile-edit'
      #   parent : 'public.profile'

      # .state 'public.profile.edit.reg-popup',
      #   url : 'edit/popups/registration'
      #   controller : 'profileController'
      #   controllerAs : 'profileCtrl'
      #   templateUrl : 'views/profile-edit'
      #   parent : 'public.profile'

      # .state 'public.contacts',
      #   url : 'contacts'
      #   templateUrl : 'views/contacts'
      #   controller : 'contactsController'
      #   controllerAs : 'contactsCtrl'
      #   parent : 'public.profile'

      # .state 'public.contacts.popup',
      #   url : 'contacts/popup'
      #   templateUrl : 'views/contacts'
      #   controller : 'contactsController'
      #   controllerAs : 'contactsCtrl'
      #   parent : 'public.profile'


    $urlRouterProvider.otherwise '/'

    $locationProvider.html5Mode
      enabled : yes
      requireBase : no
      html5Mode : yes
]
