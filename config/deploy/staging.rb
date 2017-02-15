BUILD_CONFIG = {
    domain: 'start-life.rademade.com',
    apiPrefix: 'http://start-life.rademade.com/api',
    publicPrefix: 'http://start-life.rademade.com/public',
    imagePrefix: 'http://start-life.rademade.com',
    socialPrefix: 'http://start-life.rademade.com/'
}

set :deploy_to, '/home/start-life/website-frontend'

server 'start-life.rademade.com', user: 'start-life', roles: %w{web app}

set :repo_url, 'git@github.com-frontend:Rademade/start-life-frontend.git'
