require 'test/unit'
$: << File.dirname(__FILE__) + "/.."
require 'tests/setup'

require 'submission'

class TCSubmissionSubmit < Test::Unit::TestCase

  def test_sitting_end_date_expanding
    start_time = Time.local(2011,05,20, 10,00,00)
    end_time = start_time + 10.minutes
    sitting = Sitting.create(:start_time => start_time, :end_time => end_time)

    submission = Submission.new
    submission.labels = ["test"]
    submission.start_time = start_time + 5.minutes
    submission.end_time = end_time + 5.minutes
    submission.submit

    sitting.reload
    assert_equal(end_time + 5.minutes, sitting.end_time, "end time of sitting is expanded with new entry")
    assert_equal(start_time, sitting.start_time, "start time is unchanged")
  end

  def teardown
    DatabaseCleaner.clean
  end
end
