require 'action/submit'

module Action
  def self.parse(argv)
    submit = Submit.new
    submit.labels = argv
    submit.start_time = 10.minutes.ago
    submit.end_time = Time.now

    submit
  end
end
