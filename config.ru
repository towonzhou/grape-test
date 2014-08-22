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
