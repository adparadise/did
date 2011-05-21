require 'test/unit'
$: << File.dirname(__FILE__) + "/../.."
require 'tests/setup'

require 'action/submit'

class TCSubmitPerform < Test::Unit::TestCase

  def test_sitting_end_date_expanding
    start_time = Time.local(2011,05,20, 10,00,00)
    end_time = start_time + 10.minutes
    sitting = Sitting.create(:start_time => start_time, :end_time => end_time)

    submission = Action::Submit.new
    submission.labels = ["test"]
    submission.start_time = start_time + 5.minutes
    submission.end_time = end_time + 5.minutes
    submission.perform

    sitting.reload
    assert_equal(end_time + 5.minutes, sitting.end_time, "Should expand end time of sitting with new entry")
    assert_equal(start_time, sitting.start_time, "Should not change start time")
  end

  def test_using_current_sitting
    start_time = Time.local(2011,05,21, 10,00,00)
    end_time = start_time + 10.minutes
    sitting = Sitting.create(:start_time => start_time, :current => true)
    
    submission = Action::Submit.new
    submission.labels = ["test"]
    submission.start_time = start_time
    submission.end_time = end_time
    submission.perform
    
    sitting.reload
    assert_equal(false, sitting.current, "Should clear current flag")
    assert_equal(sitting.end_time, end_time, "Should use span's end time")
  end

  def teardown
    DatabaseCleaner.clean
  end
end
