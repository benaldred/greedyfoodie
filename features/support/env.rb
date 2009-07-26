# Sets up the Rails environment for Cucumber
ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
require 'cucumber/rails/world'
require 'cucumber/formatter/unicode' # Comment out this line if you don't want Cucumber Unicode support


require 'webrat'

Webrat.configure do |config|
  config.mode = :rails
end

def reset_test_db!
  DB.recreate! rescue nil 
  DB
end

Before do
  reset_test_db!
end


require 'cucumber/rails/rspec'
require 'webrat/core/matchers'
