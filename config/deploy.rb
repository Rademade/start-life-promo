set :deploy_to, '/home/start-life/website-frontend'
set :linked_dirs, %w{bower_components node_modules}

namespace :deploy do
  after :updated, 'npm:install' do
    on roles(:web) do
      within release_path do
        execute :npm, :install
      end
    end
  end

  after :updated, 'bower:install' do
    on roles(:web) do
      within release_path do
        execute :bower, :install
      end
    end
  end

  after :updated, 'gulp:install' do
    on roles(:web) do
      within release_path do
        execute "cd #{release_path} && BUILD_CONFIG='#{BUILD_CONFIG.to_json}' #{fetch :rvm_path}/bin/rvm #{fetch :rvm_ruby_version} do node_modules/.bin/gulp build:production"
      end
    end
  end
end
