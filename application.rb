# -*- encoding: UTF-8 -*-
##############################################################
# File Name: application.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 六  8/23 01:46:55 2014
##############################################################

# set database connection
require 'active_record'

ActiveRecord::Base.establish_connection(YAML::load(File.open('config/database.yml'))[ENV["RACK_ENV"]])
ActiveSupport.on_load(:active_record) do
  self.include_root_in_json = false
  self.default_timezone = :local
  self.time_zone_aware_attributes = false
end

#load all file
%w{lib app}.each do |dir|
  Dir.glob(File.expand_path("../#{dir}", __FILE__) + '/**/*.rb').each do |file|
    require file
  end
end

# initialize log
require 'logger'
Dir.mkdir('log') unless File.exist?('log')
class ::Logger; alias_method :write, :<<; end
log_file = "#{ENV["RACK_ENV"]}.log"

case ENV["RACK_ENV"]
  when "production"
    $common_logger = ::Logger.new(log_file)
  else
    $common_logger = ::Logger.new("/dev/null")
end
ActiveRecord::Base.logger = $common_logger
