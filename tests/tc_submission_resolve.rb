require 'test/unit'
$: << File.dirname(__FILE__) + "/.."
require 'tests/setup'

require 'submission'

class TCSubmissionResolve < Test::Unit::TestCase
  def test_start_time_within_sitting
    start_time = Time.local(2011,05,20, 10,00,00)
    end_time = start_time + 10.minutes
    sitting = Sitting.create(:start_time => start_time, :end_time => end_time)
    
    submission = Submission.new
    submission.start_time = start_time + 5.minutes
    submission.resolve
    
    assert_equal(end_time + 1.second, submission.start_time, "start time gets moved to current end of sitting")
  end

  def test_start_time_outside_of_sitting
    start_time = Time.local(2011,05,04, 10,00,00)
    submission = Submission.new
    submission.start_time = start_time
    submission.resolve
    
    assert_equal(start_time, submission.start_time)
  end
  
  def teardown
    DatabaseCleaner.clean
  end
end
