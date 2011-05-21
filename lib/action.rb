require 'action/submit'
require 'action/start_sitting'
require 'action/report'

module Action
  def self.parse(argv)
    if argv == ["sit"]
      parse_start_sitting(argv)
    elsif argv[0] == "what?"
      parse_report(argv)
    else
      parse_submit(argv)
    end
  end

  private

  def self.parse_start_sitting(argv)
    start_sitting = StartSitting.new
    start_sitting.start_time = Time.now

    start_sitting
  end

  def self.parse_submit(argv)
    submit = Submit.new
    submit.labels = argv
    submit.start_time = 10.minutes.ago
    submit.end_time = Time.now

    submit
  end

  def self.parse_report(argv)
    report = Report.new
    
    report.context = :day
    report.range = Date.today

    report
  end
end
