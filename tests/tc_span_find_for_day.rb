require 'test/unit'
$: << File.dirname(__FILE__) + "/.."
require 'tests/setup'

require 'did/span'

class TCSpanFindForDay < Test::Unit::TestCase
  
  def test_date_range
    today = Date.civil(2011,10,05)
    
    span_1 = Did::Span.create(:start_time => today - 1.hour,
                              :end_time   => today - 50.minutes)
    span_2 = Did::Span.create(:start_time => today - 5.minutes,
                              :end_time   => today + 5.minutes)
    span_3 = Did::Span.create(:start_time => today + 15.minutes, 
                              :end_time   => today + 25.minutes)
    span_4 = Did::Span.create(:start_time => today + 23.hours + 55.minutes,
                              :end_time   => today + 1.day + 5.minutes)
    span_5 = Did::Span.create(:start_time => today + 1.day + 10.minutes, 
                              :end_time   => today + 1.day + 20.minutes)
    
    spans = Did::Span.find_for_day(today)

    assert_equal(span_2, spans[0])
    assert_equal(span_3, spans[1])
    assert_equal(span_4, spans[2])
    assert_equal(3, spans.length)
  end


  def teardown
    DatabaseCleaner.clean
  end
end
