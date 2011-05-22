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

    def perform
      tags = labels.map do |label|
        Tag.find_or_create_by_label(label);
      end
      
      prior_sitting = Sitting.find_current
      current_sitting = nil
      sitting_start = true
      if prior_sitting && prior_sitting.end_time.nil?
        if prior_sitting.start_time > @start_time
          @start_time = prior_sitting.start_time
        end
        current_sitting = prior_sitting
        prior_sitting = nil
      elsif prior_sitting && prior_sitting.end_time > @start_time
        @start_time = prior_sitting.end_time + 1.second
        current_sitting = prior_sitting
        sitting_start = false
      end

      span = Span.create(:tags => tags, 
                         :end_time => @end_time, :start_time => @start_time,
                         :sitting_start => sitting_start, :sitting_end => true)

      # We are about to start a new sitting, so we close out the old.
      if prior_sitting && current_sitting.nil?
        prior_sitting.update_attributes(:current => false)
      end

      if current_sitting
        # Shift end time of sitting to include new span.
        current_sitting.end_span.update_attributes(:sitting_end => false) if current_sitting.end_span
        params = {
          :end_time => @end_time,
          :end_span_id => span.id
        }

        # We are commandeering the last sitting created by a 'sit' action.
        params[:start_time] = @start_time if current_sitting.end_time.nil?
        current_sitting.update_attributes(params)
      end
      
      unless current_sitting 
        current_sitting = Sitting.create(:start_time => @start_time, :end_time => @end_time, 
                                         :end_span_id => span.id, :current => true)
      end

      span.update_attributes(:sitting_id => current_sitting.id)
    end
  end
end
