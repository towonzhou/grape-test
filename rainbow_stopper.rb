# -*- encoding: UTF-8 -*-
##############################################################
# File Name: rainbow_stopper.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 六  8/23 01:57:31 2014
##############################################################

#encoding: utf-8
require 'fileutils'

current_path = File.dirname(File.dirname(File.expand_path(__FILE__)))
current_path = File.dirname(File.expand_path(__FILE__))
puts "current path: #{current_path}"

rainbows_pid = File.join(current_path, 'tmp/pids/rainbows.pids')

if File.exist?(rainbows_pid)
  pid = File.read(rainbows_pid)
  puts "Exit rainbows running on: #{pid}"
  Process.kill('QUIT', pid.to_i) rescue nil

  FileUtils.rm_rf(rainbows_pid)
  sleep 5
else
  puts "No rainbows is running due to pid: #{rainbows_pid}"
end
