

module Did
  module Action
    class Report
      attr_accessor :format
      attr_accessor :range

      def initialize
      end
      
      def perform
        case @format
        when :timeline
          perform_timeline
        when :tags
          perform_tags
        end
      end

      def perform_timeline
        timeline_report(Span.find_for_day(@range))
      end

      def perform_tags
        tags_report(Span.find_for_day(@range))
      end

      def timeline_report(spans)
        spans.each do |span|
          sitting_char = "|"
          if span.entire_sitting?
            sitting_char = "]"
          elsif span.sitting_start?
            sitting_char = "\\"
          elsif span.sitting_end?
            sitting_char = "/"
          end
          
          puts "#{span.start_time} - #{span.end_time} (#{duration_to_s(span.duration)}): #{sitting_char} #{span.tags.map{|t| t.label}.join(", ")}"
        end
      end
      
      def tags_report(spans)
        tag_totals = Hash.new{|hash, key| hash[key] = 0}
        spans.each do |span|
          span.tags.each do |tag|
            tag_totals[tag.label]+= span.duration
          end
        end
        max_length = tag_totals.keys.map(&:length).max
        tag_totals = tag_totals.sort{|a, b| a[1] <=> b[1]}.reverse
        tag_totals.each do |tag_label, duration|
          puts "#{tag_label.ljust(max_length + 3)}  #{duration_to_s(duration)}"
        end
      end

      def duration_to_s(duration)
        total_seconds = duration.floor
        milliseconds = duration - total_seconds
        seconds = total_seconds % 60
        minute_seconds = (total_seconds - seconds) % 3600
        hour_seconds = total_seconds - seconds - minute_seconds
        
        "%03d:%02d:%02d" %  [hour_seconds / 3600, minute_seconds / 60, seconds]
      end
    end
  end
end
