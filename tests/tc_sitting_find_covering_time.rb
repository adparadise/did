require 'test/unit'
$: << File.dirname(__FILE__) + "/.."
require 'tests/setup'

require 'sitting'

class TCSittingFindCoveringTime < Test::Unit::TestCase
  def setup
    @start_time = Time.local(2011, 05, 21, 11, 00, 00)
    @end_time = @start_time + 10.minutes
    @sitting = Sitting.create(:start_time => @start_time, :end_time => @end_time)
  end

  def test_found_within_sitting
    found_sitting = Sitting.find_covering_time(@start_time + 5.minutes)
    assert_equal(@sitting, found_sitting)
  end

  def test_not_found_one_second_late
    found_sitting = Sitting.find_covering_time(@end_time + 1.second)
    assert_equal(nil, found_sitting)
  end

  def teardown
    DatabaseCleaner.clean
  end
end
