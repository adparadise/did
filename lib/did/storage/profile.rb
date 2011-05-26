require 'active_record'
require 'pathname'
require 'sqlite3'

require 'did/storage/version'

module Did
  module Storage
    class Profile
      def self.prepare(profile_name, allow_create = true)
        profile = Profile.new(profile_name)
        return profile if !profile.prepared? && allow_create == false

        profile.update
        profile.open

        profile
      end

      def initialize(profile_name)
        @profile_name = profile_name
      end

      def update
        profile_home.mkpath
        
        while version_number < Version::MAX_VERSION_NUMBER
          next_version = Version.get_version(version_number + 1)
          next_version.update(profile_home)
        end
      end

      def open
        config = {"adapter" => 'sqlite3', "database" => database_path.to_s}
        ActiveRecord::Base.establish_connection(config)
      end

      def prepared?
        version_number > 0
      end

      def version_number
        Version.version_number_of_profile(profile_home)
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
