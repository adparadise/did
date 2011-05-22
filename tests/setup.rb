$: << File.realpath(File.dirname(__FILE__) + "/../lib")
ENVIRONMENT_NAME = 'test'

require 'did/env'
Env.setup_development('test')

require 'tests/helpers'

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

