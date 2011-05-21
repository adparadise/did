

class Span < ActiveRecord::Base
  has_and_belongs_to_many :tags

  def entire_sitting?
    sitting_start? && sitting_end?
  end

  def self.find_covering_time(time)
    find(:first, :conditions => ["start_time < ? AND end_time >= ?", time, time])
  end

  def self.find_for_day(date)
    Span.find(:all, :conditions => ["end_time >= ? AND start_time <= ?", date, date + 1.day], :order => :start_time)
  end

end
