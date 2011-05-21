#!/usr/bin/env ruby

require 'pathname'
tests_home = Pathname.new(__FILE__).dirname


tests_home.each_entry do |entry|
  next unless entry.to_s=~ /^test_.+\.rb$/
  
  load tests_home + entry
end
