整体项目选型

基础框架选用Grape,该项目不需要输出任何html页面,只需要实现简单的http接口.
ORM层使用ActiveRecord,存在表间关联查询,放弃使用mongodb,转用mysql,故而选择AR.
Web服务器使用Rainbows,支持多进程.
部署使用capistrano,最好的部署工具.

项目的加载顺序

0.config/rainbows.rb
服务器设置

# rainbows config
worker_processes 4
Rainbows! do
  use :ThreadSpawn
  worker_connections 100
end

# paths and things
wd          = File.expand_path('../../', __FILE__)
tmp_path    = File.join(wd, 'tmp','pids')
log_path    = File.join(wd, 'log')

Dir.mkdir(tmp_path) unless File.exist?(tmp_path)
pid_path    = File.join(tmp_path, 'rainbows.pids')
err_path    = File.join(log_path, 'rainbows.error.log')
out_path    = File.join(log_path, 'rainbows.out.log')


# If running the master process as root and the workers as an unprivileged
# user, do this to switch euid/egid in the workers (also chowns logs):
# user "unprivileged_user", "unprivileged_group"

# tell it where to be
working_directory wd

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen 38000, :tcp_nopush => false

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

# feel free to point this anywhere accessible on the filesystem
pid pid_path

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
stderr_path err_path
stdout_path out_path

preload_app true

before_fork do |server, worker|
  # # This allows a new master process to incrementally
  # # phase out the old master process with SIGTTOU to avoid a
  # # thundering herd (especially in the "preload_app false" case)
  # # when doing a transparent upgrade.  The last worker spawned
  # # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"

  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
  #
  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1
end
1.config.ru
Rainbows还是一款Rack服务器.启动就是通过加载config.ru开始.

# This file is used by Rack-based servers to start the application.
#加载boot.rb
require ::File.expand_path('../boot',  __FILE__)
#管理AR的数据库链接,确保每次数据库链接使用完毕之后,都可正确释放掉.
use ActiveRecord::ConnectionAdapters::ConnectionManagement

logger = Logger.new("log/#{ENV["RACK_ENV"]}.log")
#设置服务器的log
use Rack::CommonLogger, logger

# 运行Api
run ::UsersApi
2.boot.rb
设定运行环境

require 'rubygems'

# Set rack environment
ENV['RACK_ENV'] ||= "development"

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Bundler.require(:default, ENV['RACK_ENV'])

# Set project configuration
require Filmultistage"

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
