require 'sitting'

module Action
  class StartSitting

    def perform
      current_sitting = Sitting.find(:first, :conditions => {:current => true})

      if current_sitting
        current_sitting.update_attributes(:start_time => Time.now)
      else
        current_sitting = Sitting.create(:start_time => Time.now, :current => true)
      end
    end
  end
end
