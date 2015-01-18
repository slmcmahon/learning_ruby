require 'yaml'
require 'logger'
require 'active_record'

# This is based on the Rakefile at: 
# http://exposinggotchas.blogspot.com/2011/02/activerecord-migrations-without-rails.html
namespace :db do
  task :environment do
    DATABASE_ENV = ENV['DATABASE_ENV'] || 'development'
    MIGRATIONS_DIR = ENV['MIGRATIONS_DIR'] || 'db/migrate'
  end
  
  task :configuration => :environment do
    @config = YAML.load_file('config/database.yaml')[DATABASE_ENV]
  end
  
  task :configure_connection => :configuration do
    ActiveRecord::Base.establish_connection @config
    ActiveRecord::Base.logger = Logger.new STDOUT if @config['logger']
  end
  
  desc 'Create the database from config/database.yml for the current DATABASE_ENV'
  task :create => :configure_connection do
    # I don't yet understand this.  I thought that ActiveRecord::Base.establish_connection
    # would be sufficient to create a sqlite database, but I found that this did not happen
    # as expected, but when I called the following method, it resulted in the database 
    # creation, so I am leaving it as something that works until I can understand.
    ActiveRecord::Migrator.current_version
  end
  
  desc 'Drops the database for the current DATABASE_ENV'
  task :drop => :configuration do 
    FileUtils.rm_rf @config['database']
  end
  
  desc 'Migrate the database (options: Version=x, VERBOSE=false)'
  task :migrate => :configure_connection do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate MIGRATIONS_DIR, ENV['VERSION'] ? ENV['VERSION'].to_i : nil
  end
  
  desc 'Rolls the schema back to the previous version (specify steps w /STEP=n).'
  task :rollback => :configure_connection do
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback MIGRATIONS_DIR, step
  end
  
  desc 'Retrieves the current schema version number'
  task :version => :configure_connection do
    puts "Current version: #{ActiveRecord::Migrator.current_version}"
  end
end