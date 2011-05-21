$: << File.realpath(File.dirname(__FILE__) + "/../lib")
ENVIRONMENT_NAME = 'test'

require 'env'
Env.setup

require 'tests/helpers'

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

