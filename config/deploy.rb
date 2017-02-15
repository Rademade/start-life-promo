set :deploy_to, '/home/start-life/website-frontend'
set :linked_dirs, %w{bower_components node_modules}
set :gulp_tasks, 'build:production'

namespace :deploy do
  before :updated, 'gulp'

  after :updated, 'bower:install' do
    on roles(:web) do
      within release_path do
        execute :bower, :install
      end
    end
  end
end
