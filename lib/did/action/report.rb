

module Did
  module Action
    class Report
      attr_accessor :context
      attr_accessor :range

      def initialize
      end
      
      def perform
        case @context
        when :day
          perform_day
        end
      end

      def perform_day
        report(Span.find_for_day(@range))
      end

      def report(spans)
        spans.each do |span|
          sitting_char = "|"
          if span.entire_sitting?
            sitting_char = "]"
          elsif span.sitting_start?
            sitting_char = "\\"
          elsif span.sitting_end?
            sitting_char = "/"
          end
          
          puts "#{span.start_time} - #{span.end_time}: #{sitting_char} #{span.tags.map{|t| t.label}.join(", ")}"
        end
      end
    end
  end
end
