

class Sitting < ActiveRecord::Base
  def self.find_covering_time(time)
    find(:first, :conditions => ["start_time < ? AND end_time >= ?", time, time])
  end
end
