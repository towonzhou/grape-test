# -*- encoding: UTF-8 -*-
##############################################################
# File Name: app.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 六  8/23 01:18:46 2014
##############################################################

require 'grape'

module Twitter
  class API < Grape::API
    resource :statuses do
      get :public_timeline do
        return "hello"
      end
    end
  end
end
