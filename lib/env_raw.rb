require 'rubygems'
require 'bundler'
Bundler.setup
require 'sqlite3'

$: << File.dirname(__FILE__)

class Env
  def self.database_config(environment_name)
    database_config_path = 'db/config.yml'
    raise "database configuration file not found at: #{database_config_path}" unless File.exist?(database_config_path)
    config_all = YAML.load(File.read(database_config_path))
    config = config_all[environment_name]
    raise "#{environment_name} environment not configured in #{database_config_path}" unless config
    
    config
  end

  def self.setup
    
  end

  def self.db
    config = database_config('development')
    db_filename = config["database"]
    raise "file not found: #{db_filename}" unless File.exist?(db_filename)
    SQLite3::Database.new(db_filename)
  end
end
