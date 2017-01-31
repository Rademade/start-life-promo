module.exports =

  setup: (app, appDir) ->

    app.get '*', (req, res) ->
      res.status(200).sendFile(appDir + '/index.html')

