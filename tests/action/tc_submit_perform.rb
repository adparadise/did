require 'test/unit'
$: << File.dirname(__FILE__) + "/../.."
require 'tests/setup'

require 'action/start_sitting'
require 'action/submit'

class TCSubmitPerform < Test::Unit::TestCase

  def test_sitting_end_date_expanding
    start_time = Time.local(2011,05,20, 10,00,00)
    end_time = start_time + 10.minutes
    sitting = Sitting.create(:start_time => start_time, :end_time => end_time)

    perform_action(:submit, :labels => ["test"], 
                   :start_time => start_time + 5.minutes, :end_time => end_time + 5.minutes)

    sitting.reload
    assert_equal(end_time + 5.minutes, sitting.end_time, "Should expand end time of sitting with new entry")
    assert_equal(start_time, sitting.start_time, "Should not change start time")
  end

  def test_sitting_near_prior_span
    start_time = Time.local(2011,05,20, 10,00,00)
    end_time = start_time + 10.minutes
    perform_action(:submit, :labels => ["test"],
                   :start_time => start_time, :end_time => end_time)
    
    perform_action(:start_sitting, :start_time => end_time + 2.minutes)

    perform_action(:submit, :labels => ["test"],
                   :start_time => start_time + 4.minutes, :end_time => end_time + 4.minutes)
    
    sittings = Sitting.find(:all, :order => :start_time)
    spans = Span.find(:all, :order => :start_time)

    assert_equal(2, sittings.length,                   "Should create two sittings")
    assert_equal(nil, sittings.detect{|s| s.current?}, "Neither sitting should be current")
    
    assert_equal(2, spans.length,                              "Should create two spans")
    assert_not_equal(spans[0].sitting_id, spans[1].sitting_id, "Should belong to two different sittings")
  end

  def test_using_current_sitting
    start_time = Time.local(2011,05,21, 10,00,00)
    end_time = start_time + 10.minutes
    sitting = Sitting.create(:start_time => start_time, :current => true)
    
    perform_action(:submit, :labels => ["test"], 
                   :start_time => start_time, :end_time => end_time)
    
    sitting.reload
    assert_equal(false, sitting.current, "Should clear current flag")
    assert_equal(sitting.end_time, end_time, "Should use span's end time")
  end

  def test_update_sitting_end
    start_time = Time.local(2011,05,20, 10,00,00)
    end_time = start_time + 10.minutes
    span = Span.create(:start_time => start_time, :end_time => end_time,
                       :sitting_start => true, :sitting_end => true)
    sitting = Sitting.create(:start_time => start_time, :end_time => end_time, :end_span_id => span.id)

    perform_action(:submit, :labels => ["test"], 
                   :start_time => start_time + 5.minutes, :end_time => end_time + 5.minutes)
    
    sitting.reload
    span.reload
    new_span = Span.find(:first, :conditions => {:end_time => end_time + 5.minutes})
    
    assert_equal(false, span.sitting_end?,    "Should clear sitting_end? on prior span")
    assert_equal(new_span, sitting.end_span,  "Should update sitting.end_span")
    assert_equal(true, span.sitting_start?,   "Should leave sitting_start? on prior span alone")
    assert_equal(true, new_span.sitting_end?, "Should mark new span as sitting end")
  end

  def test_initialize_sitting_start_and_end
    start_time = Time.local(2011,05,20, 10,00,00)
    end_time = start_time + 10.minutes

    perform_action(:submit, :labels => ["test"], 
                   :start_time => start_time, :end_time => end_time)

    span = Span.find(:first, :conditions => {:start_time => start_time})
    sitting = Sitting.find(:first, :conditions => {:id => span.sitting_id})

    assert_equal(true, span.sitting_start?, "Should set the span's sitting_start to true")
    assert_equal(true, span.sitting_end?,   "Should set the span's sitting_end to true")
    assert_equal(span, sitting.end_span,    "Should set sitting's end_span to new span")
  end

  def test_sitting_start_and_end_after_sit
    start_time = Time.local(2011,05,20, 10,00,00)
    end_time = start_time + 15.minutes

    perform_action(:start_sitting, :start_time => start_time)
    perform_action(:submit, :labels => ["test"], 
                   :start_time => start_time + 5.minutes, :end_time => end_time)

    span = Span.find(:first)
    sitting = Sitting.find(:first, :conditions => {:id => span.sitting_id})

    assert_equal(true, span.sitting_start?, "Should set the span's sitting_start to true")
    assert_equal(true, span.sitting_end?,   "Should set the span's sitting_end to true")
    assert_equal(span, sitting.end_span,    "Should set sitting's end_span to new span")
  end
    
  def teardown
    DatabaseCleaner.clean
  end
end
