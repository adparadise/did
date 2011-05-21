

class Span < ActiveRecord::Base
  has_and_belongs_to_many :tags

  def self.find_covering_time(time)
    find(:first, :conditions => ["start_time < ? AND end_time >= ?", time, time])
  end

end
