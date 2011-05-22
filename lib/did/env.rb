require 'active_record'
require 'pathname'
require 'sqlite3'

class Env
  def self.setup_active_record(profile_name, allow_create = true)
    initialize_home(profile_name, allow_create)
    database_path = database_path(profile_name)
    config = {"adapter" => 'sqlite3', "database" => database_path.to_s}
    ActiveRecord::Base.establish_connection(config)
  end

  def self.setup_raw(profile_name, allow_create = true)
    initialize_home(profile_name, allow_create)
  end

  def self.setup_development(environment_name)
    config = development_database_config(environment_name)
    ActiveRecord::Base.establish_connection(config)
  end

  def self.db(profile_name, allow_create = false)
    return nil if !allow_create && !database_path(profile_name).exist?
    @@db ||= SQLite3::Database.new(database_path(profile_name).to_s)
  end

  private

  def self.initialize_home(profile_name, allow_create = true)
    return if !allow_create && !database_path(profile_name).exist?

    did_home.mkpath
    database_path = database_path(profile_name)
    database_path.dirname.mkpath
    if !database_path.exist?
      puts "initializing DID database: #{database_path}"
      db = db(allow_create)
      File.readlines("db/schema.sql").each do |line|
        db.execute(line)
      end
    end
  end

  def self.did_home
    (Pathname.new('~').expand_path + ".did").realdirpath
  end

  def self.database_path(profile_name)
    did_home + profile_name + "did.db"
  end

  def self.development_database_config(environment_name)
    database_config_path = 'db/config.yml'
    raise "database configuration file not found at: #{database_config_path}" unless File.exist?(database_config_path)
    config_all = YAML.load(File.read(database_config_path))
    config = config_all[environment_name]
    raise "#{environment_name} environment not configured in #{database_config_path}" unless config
    
    config
  end
end

unless defined?(ENVIRONMENT_NAME)
  # production environment
  Env.setup_active_record(DID_PROFILE)
else
  Env.setup_development(ENVIRONMENT_NAME)
end
