require 'tag'
require 'span'
require 'sitting'

module Action
  class Submit
    attr_accessor :labels
    attr_accessor :start_time
    attr_accessor :end_time

    def initialize()
      @resolved = false
    end

    def resolve
      @sitting = Sitting.find_covering_time(start_time)
      if @sitting
        @start_time = @sitting.end_time + 1.second
      end

      @resolved = true
    end

    def perform
      resolve unless @resolved

      tags = labels.map do |label|
        Tag.find_or_create_by_label(label);
      end

      if @sitting
        @sitting.update_attributes(:end_time => @end_time)
      else
        @sitting = Sitting.create(:start_time => @start_time, :end_time => @end_time)
      end

      span = Span.create(:tags => tags, 
                         :sitting_id => @sitting.id,
                         :end_time => @end_time, 
                         :start_time => @start_time)
    end
  end
end
