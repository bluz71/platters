# Reading material:
#
# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server
#
# https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-puma-and-nginx-on-ubuntu-14-04

# Workers should usually match CPU count (give or take).
# Also make sure "workers * 250MB" is less than the size of RAM on the host
# (250MB being a typical size for a Rails application).
workers ENV["PUMA_WORKERS"] || 2

# Min and max threads per worker. Make sure database connections is set to the
# value of "workers * max threads" in config/database.yml. Don't set these
# thread values too high otherwise memory fragmentation may be experienced.
threads 4, 4

preload_app!

# Port and environment.
port        ENV["PORT"]      || 3000
environment ENV["RAILS_ENV"] || "development"

on_worker_boot do
  # Set config/database.yml pool size to workers * max threads.
  ActiveRecord::Base.establish_connection
end
