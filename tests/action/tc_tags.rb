$: << File.dirname(__FILE__) + "/../.."
require 'tests/setup'

class TCTags < Test::Unit::TestCase
  
  def test_contiguous_identical_tags
    start_time = Time.local(2011,05,21, 10,00,00)
    perform_action(:submit, :labels => ['one'],
                   :start_time => start_time, 
                   :end_time   => start_time + 10.minutes)
    perform_action(:submit, :labels => ['one'],
                   :start_time => start_time + 20, 
                   :end_time   => start_time + 30.minutes)

    spans = Did::Span.find(:all, :order => :start_time)
    assert_equal(1, spans.length,   "Should reuse first span")
  end
  
  def teardown
    DatabaseCleaner.clean
  end
end
