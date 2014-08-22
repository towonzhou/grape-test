namespace :db do

  task :environment do
    type = ENV["RAILS_ENV"] || 'development' 
    ActiveRecord::Base.establish_connection YAML::load(File.open('config/database.yml'))[type]
    ActiveRecord::Base.logger = LogSupport.logger
  end

  desc "Migrate the database through scripts in db/migrate. "
  task :migrate => :environment do
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end

end
