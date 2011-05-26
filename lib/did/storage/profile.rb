require 'active_record'
require 'pathname'
require 'sqlite3'

module Did
  module Storage
    class Profile
      def self.prepare(profile_name, allow_create = true)
        profile = Profile.new(profile_name)
        return profile if !profile.prepared? && allow_create == false

        profile.create if !profile.prepared?
        profile.open

        profile
      end

      def initialize(profile_name)
        @profile_name = profile_name
      end

      def open
        config = {"adapter" => 'sqlite3', "database" => database_path.to_s}
        ActiveRecord::Base.establish_connection(config)
      end

      def create
        did_home.mkpath
        database_path.dirname.mkpath
        if !database_path.exist?
          puts "initializing DID database: #{database_path}"
          db = SQLite3::Database.new(database_path.to_s)
          File.readlines("db/schema.sql").each do |line|
            db.execute(line)
          end
          db.close
        end
      end

      def prepared?
        version != nil
      end

      def version
        return nil if !did_home.exist? || !database_path.exist?
        
        return 1
      end

      private

      def did_home
        Pathname.new('~').expand_path + ".did"
      end

      def profile_home
        did_home + @profile_name
      end

      def database_path
        profile_home + "did.db"
      end
    end
  end
end
