$: << File.dirname(__FILE__) + "/../.."
require 'tests/setup'

require 'did/action/sit'
require 'did/action/submit'

class TCSitPerform < Test::Unit::TestCase

  def test_first_span_no_prior_sitting
    start_time = Time.local(2011,05,21, 10,00,00)
    perform_action(:submit, :labels => [],
                   :start_time => start_time, 
                   :end_time   => start_time + 10.minutes)

    spans = Did::Span.find(:all, :order => :start_time)
    sittings = Did::Sitting.find(:all, :order => :start_time)

    assert_equal(1, spans.length,                               "Should be one span")
    assert_equal(1, sittings.length,                            "Should be one sitting")
    assert_equal(true, sittings[0].current?,                    "Should mark sitting as current")
    assert_equal(spans[0].start_time, sittings[0].start_time,   "Should have matching start_times")
    assert_equal(spans[0].end_time, sittings[0].end_time,       "Should have matching start_times")

    assert_correct_sitting_bounds(spans)
  end

  def test_prior_submit_too_old
    start_time = Time.local(2011,05,21, 10,00,00)
    perform_action(:submit, :labels => ['one'],
                   :start_time => start_time, 
                   :end_time   => start_time + 10.minutes)
    perform_action(:submit, :labels => ['two'],
                   :start_time => start_time + 40.minutes,
                   :end_time   => start_time + 50.minutes)

    spans = Did::Span.find(:all, :order => :start_time)
    sittings = Did::Sitting.find(:all, :order => :start_time)

    assert_equal(2, sittings.length,                            "Should be two sittings")
    assert_equal(sittings[0], spans[0].sitting,                 "Should match first span to first sitting")
    assert_equal(sittings[1], spans[1].sitting,                 "Should match second span to second sitting")
    assert_equal(false, sittings[0].current?,                   "Should mark first sitting as not current")
    assert_equal(true, sittings[1].current?,                    "Should mark second sitting as current")

    assert_correct_sitting_bounds(spans)
  end


  def test_prior_submit_recent
    start_time = Time.local(2011,05,21, 10,00,00)
    perform_action(:submit, :labels => ['one'],
                   :start_time => start_time, 
                   :end_time   => start_time + 10.minutes)
    perform_action(:submit, :labels => ['two'],
                   :start_time => start_time + 5.minutes,
                   :end_time   => start_time + 15.minutes)

    spans = Did::Span.find(:all, :order => :start_time)
    sittings = Did::Sitting.find(:all, :order => :start_time)

    assert_equal(1, sittings.length,                            "Should be one sitting")
    assert_equal(sittings[0], spans[0].sitting,                 "Should match first span to first sitting")
    assert_equal(sittings[0], spans[1].sitting,                 "Should match second span to first sitting")
    assert_equal(true, sittings[0].current?,                    "Should mark first sitting as current")

    assert_correct_sitting_bounds(spans)
  end

  def test_prior_sit_recent
    start_time = Time.local(2011,05,21, 10,00,00)
    perform_action(:sit,
                   :start_time => start_time)
    perform_action(:submit, :labels => [],
                   :start_time => start_time - 5.minutes,
                   :end_time   => start_time + 5.minutes)
    
    spans = Did::Span.find(:all, :order => :start_time)
    sittings = Did::Sitting.find(:all, :order => :start_time)

    assert_equal(1, sittings.length,                            "Should be one sitting")
    assert_equal(start_time, spans[0].start_time,               "Span should use sit's start time")
    assert_equal(start_time + 5.minutes, sittings[0].end_time,  "Sitting should use span's end time")
    assert_equal(true, sittings[0].current?,                    "Should mark sitting as current")

    assert_correct_sitting_bounds(spans)
  end  


  def test_prior_sit_too_old
    start_time = Time.local(2011,05,21, 10,00,00)
    perform_action(:sit,
                   :start_time => start_time)
    perform_action(:submit, :labels => [],
                   :start_time => start_time + 25.minutes,
                   :end_time   => start_time + 35.minutes)
    
    spans = Did::Span.find(:all, :order => :start_time)
    sittings = Did::Sitting.find(:all, :order => :start_time)

    assert_equal(1, sittings.length,                            "Should be one sitting")
    assert_equal(start_time + 25.minutes, spans[0].start_time,  "Span should use span's start time")
    assert_equal(start_time + 35.minutes, sittings[0].end_time, "Sitting should use span's end time")
    assert_equal(true, sittings[0].current?,                    "Should mark sitting as current")

    assert_correct_sitting_bounds(spans)
  end  

  def test_sit_after_submit
    start_time = Time.local(2011,05,21, 10,00,00)
    perform_action(:submit, :labels => [],
                   :start_time => start_time,
                   :end_time   => start_time + 10.minutes)
    perform_action(:sit,
                   :start_time => start_time + 15.minutes)
    perform_action(:submit, :labels => [],
                   :start_time => start_time + 8.minutes,
                   :end_time   => start_time + 18.minutes)

    spans = Did::Span.find(:all, :order => :start_time)
    sittings = Did::Sitting.find(:all, :order => :start_time)
    
    assert_equal(2, sittings.length,                            "Should be two sittings")
    assert_equal(start_time + 15.minutes, sittings[1].start_time)
    assert_equal(start_time + 18.minutes, sittings[1].end_time)
    
    assert_correct_sitting_bounds(spans)
  end

  def test_double_sit
    start_time = Time.local(2011,05,21, 10,00,00) 
    perform_action(:sit,
                   :start_time => start_time)
    perform_action(:sit,
                   :start_time => start_time + 1.minute)

    sittings = Did::Sitting.find(:all, :order => :start_time)
    
    assert_equal(1, sittings.length,                            "Should be one sitting")
  end



  def teardown
    DatabaseCleaner.clean
  end
end
