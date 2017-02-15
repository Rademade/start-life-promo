require 'json'

ruby_version = File.read(File.join __dir__, '../../.ruby-version').chomp
set :rvm_ruby_version, ruby_version

set :default_env, fetch(:default_env).merge({
  BUILD_CONFIG: {
      domain: 'start.live',
      apiPrefix: 'http://start.live/api',
      publicPrefix: 'http://start.live/public',
      imagePrefix: 'http://start.live',
      socialPrefix: 'http://start.live/'
  }.to_json
})

server 'vm.rademade.com:2234', user: 'start-life', roles: %w{web app}

set :repo_url, 'git@github.com:Rademade/start-life-promo.git'
