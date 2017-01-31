app.service 'browser', [ 'deviceDetector', (deviceDetector) ->

  BROWSERS = [
    { name : 'chrome',  minVersion : 40 },
    { name : 'firefox', minVersion : 40 },
    { name : 'opera',   minVersion : 30 }
  ]

  isAvailable : ->
    @availableBrowser() && @currentVersion() > @availableBrowser().minVersion

  currentVersion : ->
    Number(deviceDetector.browser_version.split('.')[0])

  availableBrowser : ->
    _.find BROWSERS, (browser) -> browser.name is deviceDetector.browser

  isChromeAvailable : ->
    @isAvailable() && @availableBrowser().name is 'chrome'

]
