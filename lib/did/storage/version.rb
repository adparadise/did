

require 'did/storage/version/version_1'

module Did
  module Storage
    module Version
      MAX_VERSION_NUMBER = 1

      def self.get_version(number)
        version_class = Version.const_get("Version#{number}")
        version_class.new
      end

      def self.version_number_of_profile(profile_path)
        return 0 if !database_path(profile_path).exist?
        
        return 1
      end

      def self.database_path(profile_path)
        profile_path + "did.db"
      end
    end
  end
end
