app.controller('newsPreviewController', [
  '$scope', 'newsMaker', 'newsService', 'NewsCategory',
  ($scope, newsMaker, newsService, NewsCategory) ->

    @news = []

    @updateFeed = ->
      category = newsService.getCategory()
      category = newsService.getSubCategory() if $scope.service.isSubCategories()
      site = newsService.getSite()

      if category
        @news = []
        new NewsCategory(siteId : site.id, id : category.id).rss().then (data) =>
          @news = newsMaker.process(data)

    @fullView = (newNews) ->
      _.each @news, (news) ->
        news.fullView = news is newNews
        yes

    $scope.$watch () ->
      $scope.service.getCategory()
    , (newCategory, oldCategory) =>
      $scope.service.setSubCategory(newCategory.subCategories[0]) if $scope.service.isSubCategories()

      @updateFeed()

    $scope.$watch () ->
      $scope.service.getSubCategory()
    , =>
      @updateFeed()

    return
]).config ($httpProvider) ->
  $httpProvider.interceptors.push('xmlHttpInterceptor')
