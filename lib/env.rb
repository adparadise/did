require 'rubygems'
require 'bundler'
Bundler.setup
require 'active_record'
require 'pathname'
require 'sqlite3'

DID_PROFILE = ENV['DID_PROFILE'] || 'default'

class Env
  def self.setup_active_record(allow_create = true)
    initialize_home(DID_PROFILE, allow_create)
    database_path = database_path(DID_PROFILE)
    config = {"adapter" => 'sqlite3', "database" => database_path.to_s}
    ActiveRecord::Base.establish_connection(config)
  end

  def self.setup_raw(allow_create = true)
    initialize_home(DID_PROFILE, allow_create)
  end

  def self.setup_development(environment_name)
    config = development_database_config(environment_name)
    ActiveRecord::Base.establish_connection(config)
  end

  def self.db(allow_create = false)
    return nil if !allow_create && !database_path(DID_PROFILE).exist?
    @@db ||= SQLite3::Database.new(database_path(DID_PROFILE).to_s)
  end

  private

  def self.initialize_home(profile, allow_create = true)
    return if !allow_create && !database_path(profile).exist?

    did_home.mkpath
    database_path = database_path(profile)
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

  def self.database_path(profile)
    did_home + profile + "did.db"
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
