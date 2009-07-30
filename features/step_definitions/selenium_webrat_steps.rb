# standard webrat steps changed slightly to work better with selenium
# webrat is running some commands before the page is loaded.

When /^I press "([^\"]*)" and wait$/ do |button|
  click_button(button)
  selenium.wait_for_page
end

When /^I follow "([^\"]*)" and wait$/ do |link|
  click_link(link)
  selenium.wait_for_page
end
