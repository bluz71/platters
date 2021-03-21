# Mina setup on a development machine:
#
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
# Deployment with full asset precompilation:
#
#   % mina deploy force_asset_precompile=true
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
set :domain, "platters-sgp3"
set :deploy_to, "/home/deploy/platters_deploy"
set :repository, "https://github.com/bluz71/platters.git"
set :branch, "master"
set :user, "deploy"

set :shared_dirs, fetch(:shared_dirs, []).push("tmp/sockets")
set :shared_files, fetch(:shared_files, []).push("config/application.yml")
set :shared_dirs, fetch(:shared_dirs, []).push("node_modules")

# Add in support for webpacker: https://is.gd/iZFSxw, https://is.gd/cjawkG
set :asset_dirs, fetch(:asset_dirs, []).push("app/javascript/")
set :shared_dirs, fetch(:shared_dirs, []).push("public/packs")

set :chruby_path, "/home/linuxbrew/.linuxbrew/share/chruby/chruby.sh"

# Quiet Bundler 2 deprecation warnings: https://is.gd/bSFK1Y
set :bundle_options, -> { "" }
task :setup do
  command "#{fetch(:bundle_bin)} config set deployment 'true'"
  command "#{fetch(:bundle_bin)} config set path '#{fetch(:bundle_path)}'"
  command "#{fetch(:bundle_bin)} config set without '#{fetch(:bundle_withouts)}'"
end

task :remote_environment do
  invoke :chruby, "2.6.6"
end

task deploy: :remote_environment do
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
