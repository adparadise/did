$: << File.realpath(File.dirname(__FILE__) + "/../lib")
ENVIRONMENT_NAME = 'test'

require 'active_record'
require 'pathname'
require 'sqlite3'
require 'test/unit'
require 'database_cleaner'
require 'tests/helpers'

DatabaseCleaner.strategy = :truncation

def development_database_config(environment_name)
  home = File.dirname(__FILE__) + '/../'
  database_config_path = home + 'db/config.yml'
  raise "database configuration file not found at: #{database_config_path}" unless File.exist?(database_config_path)
  config_all = YAML.load(File.read(database_config_path))
  config = config_all[environment_name]
  raise "#{environment_name} environment not configured in #{database_config_path}" unless config
  if config['adapter'] == 'sqlite3' && config['database'][0] != "/"
    config['database'] = (home + config['database'])
  end
  
  config
end

config = development_database_config(ENVIRONMENT_NAME)
ActiveRecord::Base.establish_connection(config)
DatabaseCleaner.clean

