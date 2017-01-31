app.service 'linkOpener', [ () ->

  search : (text, items) ->
    if text && items.length
      first = _.first items
      _.each items, (item) =>
        link = 'http://' + item.domain + '/' + item.searchMod + text
        link = link.replace(/\s/, '+') if item.replaceSpaces

        if item is first then @openHere(link) else @open(link)
        yes

  linkInNewTab : (domain) ->
    link = 'http://' + domain
    @open(link)

  open : (link, encode = yes) ->
    return unless link
    domain = link.match(/^(?:https?:\/\/)?(?:www.)?(.*)$/)[1] if link
    link = _.compact(['http://', domain]).join('')
    if encode
      window.open encodeURI(link), '_blank'
    else
      window.open link, '_blank'
    yes

  openHere : (link, encode = yes) ->
    return unless link
    domain = link.match(/^(?:https?:\/\/)?(?:www.)?(.*)$/)[1] if link
    link = _.compact(['http://', domain]).join('')
    if encode
      location.href = encodeURI(link)
    else
      location.href = link
    yes

]
