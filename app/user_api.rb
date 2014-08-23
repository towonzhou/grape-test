# -*- encoding: UTF-8 -*-
##############################################################
# File Name: app/user_api.rb
# Author: zhouhuan
# mail: towonzhou@gmail.com
# Created Time: 六  8/23 02:18:03 2014
##############################################################

module AllApi
  class Api1 < Grape::API
    resource :hello do
      get :hello_world do
        return "hello world!"
      end

      get "/" do
        return "no second path"
      end
    end

    get :hi do
      return "hello world!"
    end
  end

  class Api < Grape::API
    mount AllApi::Api1
  end

end

