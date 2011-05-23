require 'active_record'
require 'pathname'
require 'sqlite3'

class Env
  attr_reader :profile_name

  def initialize(profile_name, allow_create = true)
    @profile_name = profile_name
    @allow_create = allow_create
  end

  def allow_create?
    @allow_create
  end

  def setup_active_record
    initialize_home
    config = {"adapter" => 'sqlite3', "database" => database_path.to_s}
    ActiveRecord::Base.establish_connection(config)
  end

  def setup_development(environment_name)
    config = development_database_config(environment_name)
    ActiveRecord::Base.establish_connection(config)
  end

  def database_file_exist?
    database_path.exist?
  end

  def db
    return nil if !allow_create? && !database_file_exist?
    @@db ||= SQLite3::Database.new(database_path.to_s)
  end

  private

  def initialize_home
    did_home.mkpath
    database_path.dirname.mkpath
    if !database_file_exist?
      puts "initializing DID database: #{database_path}"
      File.readlines("db/schema.sql").each do |line|
        db.execute(line)
      end
    end
  end

  def did_home
    Pathname.new('~').expand_path + ".did"
  end

  def database_path
    did_home + profile_name + "did.db"
  end

  def development_database_config(environment_name)
    database_config_path = 'db/config.yml'
    raise "database configuration file not found at: #{database_config_path}" unless File.exist?(database_config_path)
    config_all = YAML.load(File.read(database_config_path))
    config = config_all[environment_name]
    raise "#{environment_name} environment not configured in #{database_config_path}" unless config
    
    config
  end
end

DID_PROFILE = ENV['DID_PROFILE'] || 'default'
$env = Env.new(DID_PROFILE, defined?(ALLOW_CREATE) ? ALLOW_CREATE : true)
exit if !$env.allow_create? && !$env.database_file_exist?
unless defined?(ENVIRONMENT_NAME)
  $env.setup_active_record
else
  $env.setup_development(ENVIRONMENT_NAME)
end
