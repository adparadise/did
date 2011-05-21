require 'rubygems'
require 'bundler'
Bundler.setup
require 'active_record'

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
    config = database_config('development')
    ActiveRecord::Base.establish_connection(config)
  end
end

Env.setup
