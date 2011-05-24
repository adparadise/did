

module Did
  class Span < ActiveRecord::Base
    has_and_belongs_to_many :tags
    belongs_to :sitting

    def entire_sitting?
      sitting_start? && sitting_end?
    end

    def self.find_for_day(date)
      Span.find(:all, :conditions => ["end_time >= ? AND start_time <= ?", date, date + 1.day], :order => :start_time)
    end

    def duration
      end_time - start_time
    end

    def include?(tag)
      tags.include? tag
    end
  end
end
