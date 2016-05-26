require 'bundler/capistrano'

#be sure to change these
set :user, 'graham'
set :domain, 'depot.gmclellan.com'
set :application, 'depot'

set :rvm_type, :user
set :rvm_ruby_string, 'ruby-2.0.0-p648'
require 'rvm/capistrano'

#file paths
set :repository, "git@github.com:gramcl/Depot.git"
set :deploy_to, "/usr/local/share/ruby/depot"

#distribute your applications across servers (the instructions below put them
# all on the same server, defined above as 'domain', adjust as necessary)
role :app, domain
role :web, domain
role :db, domain, :primary => true


set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :normalize_asset_timestamps, false
set :rails_env, :production
set :default_stage, "production"

set :linked_files, %w{database.yml}

namespace :deploy do

  desc "cause passenger to initiate a restart"
  task :restart do
  	run "touch #{current_path}/tmp/restart.txt"
  end

  desc "reload the database with seed data"
  task :seed do
  	deploy.migrations
  	run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end

  end
