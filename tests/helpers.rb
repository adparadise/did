

def perform_action(action, params = {})
  action_class = Action.const_get(action.to_s.camelize)
  action = action_class.new
  params.each do |key, value|
    setter = (key.to_s + "=").to_sym
    action.send(setter, value)
  end
  action.perform
end
