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

When /^I press "([^\"]*)" to open new window$/ do |button|
  selenium.get_eval("this.browserbot.getCurrentWindow().open('', 'postpreview')")
  click_button(button)
  selenium.wait_for_popup("postpreview", 300)
  selenium.select_window("postpreview")
end

Given /^I am logged in as "([^\"]*)" and wait$/ do |user|
  check_for_user_or_create(user, "secret")
  
  #login
  visit path_to("login")
  fill_in("user_session_login", :with => user)
  fill_in("user_session_password", :with => "secret")
  click_button("Login")
  selenium.wait_for_page
end