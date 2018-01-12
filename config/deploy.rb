# Mina setup on a development machine:
#
#   % gem install mina
#   % mina init
#
# Edit config/deploy.rb and configure as necessary
#
# Initial setup on the deployment server from the development machine:
#
#   % mina setup
#
# Log on to the deployment server and setup shared directories and files.
#
# Standard deployment:
#
#   % mina deploy
#
# Verbose deployment:
#
#   % mina -v deploy
#
# Notes:
#   https://www.ralfebert.de/tutorials/rails-deployment
#   https://www.digitalocean.com/community/tutorials/how-to-deploy-with-mina-getting-started

require "mina/rails"
require "mina/git"
require "mina/chruby"

set :application_name, "platters"
set :domain,           "platters-sgp2"
set :deploy_to,        "/home/deploy/platters_deploy"
set :repository,       "https://github.com/bluz71/platters.git"
set :branch,           "master"
set :user,             "deploy"

set :shared_dirs,  fetch(:shared_dirs,  []).push("tmp/sockets")
set :shared_files, fetch(:shared_files, []).push("config/application.yml")

set :chruby_path, "/home/linuxbrew/.linuxbrew/share/chruby/chruby.sh"

task :environment do
  invoke :chruby, "2.5.0"
end

task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command "sudo systemctl daemon-reload"
        command "sudo service puma restart"
        command "sudo service sidekiq restart"
        command "ln -s /var/www/html/.well-known ~/platters/public"
      end
    end
  end
end
