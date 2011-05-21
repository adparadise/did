

class Sitting < ActiveRecord::Base
  belongs_to :end_span, :class_name => "Span"

  def self.find_covering_time(time)
    find(:first, :conditions => ["start_time < ? AND end_time >= ?", time, time])
  end

  def self.find_current
    find(:first, :conditions => {:current => true})
  end
end
