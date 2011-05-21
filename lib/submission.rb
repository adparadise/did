require 'tag'
require 'span'

class Submission
  attr_accessor :labels
  attr_accessor :start_time
  attr_accessor :end_time

  def initialize()
    @resolved = false
  end

  def resolve
    @resolved = true
  end

  def submit
    resolve unless @resolved

    tags = labels.map do |label|
      Tag.find_or_create_by_label(label);
    end

    span = Span.create(:tags => tags, 
                       :end_time => end_time, 
                       :start_time => start_time)
  end
end
