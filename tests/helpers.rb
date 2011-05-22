

def perform_action(action, params = {})
  action_class = Did::Action.const_get(action.to_s.camelize)
  action = action_class.new
  params.each do |key, value|
    setter = (key.to_s + "=").to_sym
    action.send(setter, value)
  end
  action.perform
end


def assert_correct_sitting_bounds(spans)
  prior_sitting_id = nil
  sitting_index = 0
  sitting_span_index = 0
  0.upto(spans.length - 1) do |index|
    sitting_span_index+= 1
    span = spans[index]
    next_span = spans[index + 1]
    sitting_start = span.sitting_id != prior_sitting_id
    sitting_end = next_span.nil? || next_span.sitting_id != span.sitting_id

    location = "#{sitting_span_index}th span in #{sitting_index}th sitting"
    assert_equal(sitting_start, span.sitting_start, "#{location} sitting_start")
    assert_equal(sitting_end, span.sitting_end, "#{location} sitting_start")
    assert_equal(span.id, span.sitting.end_span_id, "sitting.end_span of #{sitting_index}th sitting") if sitting_end
    
    if prior_sitting_id != span.sitting_id
      prior_sitting_id = span.sitting_id
      sitting_span_index = 0
      sitting_index+= 1
    end
  end
end

