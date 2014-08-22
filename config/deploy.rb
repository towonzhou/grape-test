# -*- encoding: UTF-8 -*-
##############################################################
# File Name: config/deploy.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 六  8/23 01:57:59 2014
##############################################################

require "bundler/capistrano"
require "rvm/capistrano"
require "capistrano/ext/multistage"

set :stages, %w{alpha production}
set :default_stage, "alpha"

set :application, "sth"
set :repository,  "http://svn.sth.com/svn/sth/trunk/"
set :svn_username, "sennmac"
set :svn_password, "0987654321"

set :scm, :subversion
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do
    run "cd #{current_path}; ruby script/rainbow_stopper.rb"
    run "cd #{current_path}; export RAILS_ENV=production;export RACK_ENV=production; bundle exec rainbows -D -N -E production -c config/rainbows.rb config.ru"
  end

  task :links, :roles => :app, :except => { :no_release => true } do
    run "ln -sf #{deploy_to}/shared/config/database.yml #{latest_release}/config/database.yml"
  end
end

set :rvm_ruby_string, '1.9.3-p286'

after 'deploy:finalize_update', 'deploy:links'
before 'deploy:restart',  'deploy:migrate'
