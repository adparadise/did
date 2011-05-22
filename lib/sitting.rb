

class Sitting < ActiveRecord::Base
  belongs_to :end_span, :class_name => "Span"

  def self.find_current
    find(:first, :conditions => {:current => true})
  end
end
