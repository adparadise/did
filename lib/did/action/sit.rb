require 'did/sitting'

module Did
  module Action
    class Sit
      attr_accessor :start_time

      def perform
        current_sitting = Sitting.find(:first, :conditions => {:current => true})

        if current_sitting && current_sitting.end_time.nil?
          current_sitting.update_attributes(:start_time => @start_time)
        else
          current_sitting.update_attributes(:current => false) if current_sitting
          Sitting.create(:start_time => @start_time, :current => true)
        end
      end
    end
  end
end
