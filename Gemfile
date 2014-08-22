#source "https://rubygems.org"
source "http://ruby.taobao.org"

gem 'rack'
gem 'grape'

gem 'rake'
gem 'zip'

gem 'activerecord', '~> 3.2', :require => 'active_record'
gem 'activesupport'

gem 'pg'
gem 'rgeo'
gem 'activerecord-postgis-adapter'
gem 'ncommons',:git => 'git://github.com/weidewang/ncommons.git'

gem 'eventmachine'
gem 'em-http-request'

group :production do
  gem 'rainbows'
end

group :development do
  gem 'thin'
  gem 'sinatra-contrib'
  gem 'pry'
  # 下面用不到，加上2.0里才不会报错
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'pry-remote'
end

group :test do
  gem 'minitest', "~>2.6.0", :require => "minitest/autorun"
  gem 'rack-test', :require => "rack/test"
  gem 'factory_girl'
  gem 'database_cleaner'
end

gem 'redis'
gem "hiredis", "~> 0.4.5"
