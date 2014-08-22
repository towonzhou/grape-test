# -*- encoding: UTF-8 -*-
##############################################################
# File Name: console.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 六  8/23 01:56:43 2014
##############################################################

require ::File.expand_path('../../boot',  __FILE__)

require 'irb'
require 'irb/completion'

IRB.start(__FILE__)
