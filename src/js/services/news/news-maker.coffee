app.service 'newsMaker', [ () ->

  process : (data) ->
    data = @rssData(data)
    response = []
    _.each data, (news, index) =>
      item =
        date : @itemDate(news)
        title : @findTitle(news)
        description : @findDescription(news)
        image : @findImage(news)
        sref : @findLink(news)
        fullView : no
      response.push item
      yes
    @spliteOn _.orderBy(response, 'date', 'desc')

  rssData : (data) ->
    return _.first(data.rss.channel).item if data.rss.channel instanceof Array
    return data.rss.channel.item if data.rss.channel?.item
    return data.feed.entry if data.feed?.entry
    return data.RDF.item if data.RDF?.item

  itemDate : (news) ->
    return new Date(news.pubDate).getTime() if news.pubDate?
    return new Date(news.published).getTime() if news.published?
    return new Date(news.date.__text).getTime() if news.date?.__text?
    return new Date(_.first(news.date).__text) if news.date instanceof Array

  findTitle : (news) ->
    if _.has(news, 'title.__cdata')
      @replaceHtml(news.title.__cdata)
    else if news.title.__text?
      news.title.__text
    else if news.title instanceof Array
      if _.head(news.title).__cdata?
        _.head(news.title).__cdata
      else
        _.head(news.title)
    else
      news.title

  findDescription : (news) ->
    if _.has(news, 'description.__cdata')
      @replaceHtml(news.description.__cdata)
    else if news.description instanceof Array
      @replaceHtml(_.head(news.description))
    else
      @replaceHtml(news.description)

  findImage : (news) ->
    if _.has(news, 'enclosure._url')
      news.enclosure._url
    else if _.has(news, 'content._url')
      news.content._url
    else if _.has(news, 'thumbnail._url')
      news.thumbnail._url
    else if _.isArray(news.thumbnail)
      news.thumbnail[0]._url
    else
      news.image

  findLink : (news) ->
    return news.link._href if news.link?._href?
    if _.has(news, 'link.__cdata')
      news.link.__cdata
    else if news.link instanceof Array
      a = _.find(news.link, {'_rel' : 'alternate'})
      if a?._href? then a._href else _.head(news.link)
    else if !news.link? && news.content?._url?
      news.content._url
    else
      news.link

  spliteOn : (news) ->
    response = []
    date = @getDateFrom()

    _.each news, (news, index) =>
      if (new Date(news.date)).getDate() is date
        response.push news
      else
        date = @getDateFrom(news.date)
        response.push
          divider : yes
          date : news.date
        response.push news
      if index is 0
        response[0].fullView = yes
      yes
    response

  replaceHtml : (str) ->
    str.replace(/(<([^>]+)>)/ig,'').replace(/(&#160;?|&nbsp;?)/g, '') if str?.replace?

  getDateFrom : (time) ->
    if time then (new Date(time)).getDate() else (new Date()).getDate()

]
