require 'action/submit'
require 'action/start_sitting'

module Action
  def self.parse(argv)
    if argv == ["sit"]
      StartSitting.new
    else
      parse_submit(argv)
    end
  end

  private

  def self.parse_submit(argv)
    submit = Submit.new
    submit.labels = argv
    submit.start_time = 10.minutes.ago
    submit.end_time = Time.now

    submit
  end
end
