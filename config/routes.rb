# -*- encoding: UTF-8 -*-
##############################################################
# File Name: config/routes.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 六  8/23 10:51:48 2014
##############################################################

Monterail::Application.routes.draw do
  mount AllApi::Api => '/api'
end
