require 'did/action/sit'
require 'did/action/submit'
require 'did/action/report'

module Did
  module Action
    def self.parse(argv)
      if argv[0] == "sit!"
        parse_sit(argv)
      elsif argv[0] == "what?"
        parse_report(argv)
      else
        parse_submit(argv)
      end
    end

    private

    def self.parse_sit(argv)
      sit = Sit.new
      sit.start_time = Time.now

      sit
    end

    def self.parse_submit(argv)
      submit = Submit.new
      submit.labels = argv
      submit.start_time = 2.hours.ago
      submit.end_time = Time.now

      submit
    end

    def self.parse_report(argv)
      report = Report.new
      
      report.format = (argv[1] || "timeline").to_sym
      report.range = Date.today

      report
    end
  end
end
