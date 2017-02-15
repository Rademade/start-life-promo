set :deploy_to, '/home/start-life/website-frontend'
set :linked_dirs, %w{bower_components node_modules}
set :gulp_tasks, 'build:production'

namespace :deploy do
  before :updated, 'gulp'
end
