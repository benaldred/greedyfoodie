Then /^I should see an? "([^\"]*)" button$/ do |value|
  response.should have_selector("input[type='submit'][value='#{value}']")
end

Then /^I should not see an? "([^\"]*)" button$/ do |value|
  response.should_not have_selector("input[type='submit'][value='#{value}']")
end

