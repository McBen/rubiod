begin 
  require 'simplecov'
  SimpleCov.start do
    add_group "Source", "lib/"
    add_group "Test", "test/"
  end
rescue
  puts "install gem 'simplecov' to get code coverage report"
end


$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rubiod'
require 'minitest/autorun'
