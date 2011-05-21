require 'submission'

class SubmissionParser
  def self.parse(argv)
    submission = Submission.new
    submission.labels = argv
    submission.start_time = 10.minutes.ago
    submission.end_time = Time.now

    submission
  end
end
