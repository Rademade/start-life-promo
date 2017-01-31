_       = require 'lodash'

module.exports =

  _DEFAULT_VERSION: 'web'
  _RESOLVED_VERSIONS: ['web', 'ios']

  _version: null

  _defaultConfig:
    domain: 'localhost'
    imagePrefix: 'http://localhost/'
    apiPrefix: 'http://localhost/api'
    publicPrefix: 'http://localhost/public'
    socialPrefix: 'http://localhost/'
    defaultLocale: 'ru'
    availableLocales: ['en', 'ru']

  _webConfig:
    isMobile: no
    isDesktop: yes
    errorUrl: '/error'
    html5Mode: yes
    addRootSlash: yes

  _config: {}

  setVersion: (ver)->
    throw new Error("Unsupported version #{ver}") unless _.contains(@_RESOLVED_VERSIONS, ver)
    @_version = ver

  getVersion: ->
    @_version || @_DEFAULT_VERSION

  getVersionConfig: ->
    @[ ['_', @getVersion(), 'Config'].join('') ]

  getDefaultConfig: ->
    _.merge( _.clone(@_defaultConfig), @getVersionConfig() )

  setConfig: (config)->
    @_config = _.assign(@getDefaultConfig(), config)

  getConfig: ->
    @_config = @getDefaultConfig() if _.isEmpty(@_config)
    @_config
