#!/usr/bin/env ruby

$: << File.realpath(File.dirname(__FILE__) + "/../lib")
$: << File.dirname(__FILE__) + "/.."
ENVIRONMENT_NAME = 'test'

require 'did'
require 'tests/helpers'
require 'database_cleaner'
DatabaseCleaner.strategy = :truncation


WORD_COUNT = 50
SITTING_COUNT = 10
SPAN_COUNT_PER_SITTING = 10


dictionary_file = File.dirname(__FILE__) + "/../notes/dictionary_short"
words = `cat #{dictionary_file} | head -n #{WORD_COUNT}`.split("\n")
word_index = 0

time = Time.local(2001,01,01, 12,01,01)
times = []

0.upto(SITTING_COUNT) do
  times << time += 8.minutes
  0.upto(SPAN_COUNT_PER_SITTING) do
    times << time += 8.minutes
  end
end

DatabaseCleaner.clean
require 'perftools'
start_time = Time.now
puts "starting profile: #{times.length} actions"
PerfTools::CpuProfiler.start("profile/many_spans") do
  times.each_with_index do |time, index|
    if (index % (SPAN_COUNT_PER_SITTING + 1) == 0)
      action = Did::Action.parse(["sit"])
      action.perform
    else
      action = Did::Action.parse([words[index % WORD_COUNT]])
      action.perform
    end
  end
end
end_time = Time.now

puts "#{times.length} actions (#{WORD_COUNT} words, #{SPAN_COUNT_PER_SITTING}:1 span:sit) - #{end_time - start_time} #{(end_time - start_time) / times.length} per action"
