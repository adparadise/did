require 'test/unit'
$: << File.dirname(__FILE__) + "/.."
require 'tests/setup'

require 'span'

class SpanFindCoveringTimeTests < Test::Unit::TestCase
  def setup
    @start_time = Time.local(2011, 05, 21, 11, 00, 00)
    @end_time = @start_time + 10.minutes
    @span = Span.create(:start_time => @start_time, :end_time => @end_time)
  end

  def test_found_within_span
    found_span = Span.find_covering_time(@start_time + 5.minutes)
    assert_equal(@span, found_span)
  end

  def test_not_found_one_second_late
    found_span = Span.find_covering_time(@end_time + 1.second)
    assert_equal(nil, found_span)
  end

  def teardown
    DatabaseCleaner.clean
  end
end
