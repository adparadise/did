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
      @sitting = Sitting.find_current
      @start_time = @sitting.start_time if @sitting

      unless @sitting
        @sitting = Sitting.find_covering_time(start_time)
        @start_time = @sitting.end_time + 1.second if @sitting
      end

      @resolved = true
    end

    def perform
      resolve unless @resolved

      span = create_span(@sitting)
      create_or_update_sitting(@sitting, span)
    end

    private

    def create_span(prior_sitting)
      tags = labels.map do |label|
        Tag.find_or_create_by_label(label);
      end

      sitting_start = prior_sitting.nil? || prior_sitting.current?
      span = Span.create(:tags => tags, 
                         :end_time => @end_time, :start_time => @start_time,
                         :sitting_start => sitting_start, :sitting_end => true)

      span
    end

    def create_or_update_sitting(prior_sitting, span)
      sitting = prior_sitting
      if prior_sitting
        end_span = prior_sitting.end_span        
        end_span.update_attributes(:sitting_end => false) if end_span
        prior_sitting.update_attributes(:end_time => @end_time, 
                                        :current => false,
                                        :end_span_id => span.id)
      else
        sitting = Sitting.create(:start_time => @start_time, :end_time => @end_time, 
                                 :end_span_id => span.id)
      end
      span.update_attributes(:sitting_id => sitting.id)
    end
  end
end
