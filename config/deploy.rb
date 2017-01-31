lock '3.4.0'

set :application, 'StartLifeFrontend'

set :scm, :git

set :rvm_type,          :system
set :rvm_ruby_version,  'ruby-2.3.0@start-life'

set :linked_dirs, %w{bower_components node_modules}
set :keep_releases, 2

namespace :deploy do

  task 'npm:install' do
    on roles(:web) do
      within release_path do
        execute :npm, :install
      end
    end
  end

  task 'bower:install' do
    on roles(:web) do
      within release_path do
        execute :bower, :install
      end
    end
  end

  task 'gulp:install' do
    on roles(:web) do
      within release_path do
        execute "cd #{release_path} && BUILD_CONFIG='#{BUILD_CONFIG.to_json}' #{fetch :rvm_path}/bin/rvm #{fetch :rvm_ruby_version} do node_modules/.bin/gulp build:production"
      end
    end
  end

  after :updated, 'deploy:npm:install'
  after :updated, 'deploy:bower:install'
  after :updated, 'deploy:gulp:install'
  after :finishing, 'deploy:cleanup'

end
