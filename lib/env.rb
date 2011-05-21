require 'rubygems'
require 'bundler'
Bundler.setup
require 'active_record'

require 'env_raw'

class Env
  def self.setup
    config = database_config(ENVIRONMENT_NAME)
    ActiveRecord::Base.establish_connection(config)
  end
end
