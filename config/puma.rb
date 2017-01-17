# Reading material:
#
# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server
#
# https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-puma-and-nginx-on-ubuntu-14-04

# Workers should match CPU count.
workers 1

# Min and max threads per worker. Make sure database connections is set to the
# value of "workers * max threads" in config/database.yml
threads 5, 5

preload_app!

# Port and environment.
port        ENV['PORT']      || 3000
environment ENV['RAILS_ENV'] || "development"

on_worker_boot do
  # Set config/database.yml pool size to workers * max threads.
  ActiveRecord::Base.establish_connection
end
