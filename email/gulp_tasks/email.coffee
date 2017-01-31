#plugins requires

gulp = require('gulp')
email = require('gulp-email')

path = require './path.coffee'

options =
  user: 'api:key-70963bd25028a7a789ae310a23cdce44'
  url: 'https://api.mailgun.net/v3/sandboxebf40a3f8df6415e8c3480f995e4f71e.mailgun.org/messages'
  form:
    from: 'Maxym Shutyak <postmaster@sandboxebf40a3f8df6415e8c3480f995e4f71e.mailgun.org>'
    to: 'Maxym Shutyak <m@shutyak.com>'
    subject: 'Test email'

gulp.task 'email', ->
  gulp.src([ 'build/registration.html' ])
  .pipe email(options)