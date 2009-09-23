Then /^I should see an? "([^\"]*)" button$/ do |value|
  response.should have_selector("input[type='submit'][value='#{value}']")
end

Then /^I should not see an? "([^\"]*)" button$/ do |value|
  response.should_not have_selector("input[type='submit'][value='#{value}']")
end   

Then /^I should see the following html in the post body:$/ do |table|
  table.hashes.each do |html_tag|
    response.should have_selector(html_tag["tag"], :content => html_tag["content"])
  end
end


Given /^I am logged in as "([^\"]*)"$/ do |user|
  check_for_user_or_create(user, "secret")
  
  #login
  visit path_to("login")
  fill_in("user_session_login", :with => user)
  fill_in("user_session_password", :with => "secret")
  click_button("Login")
end

def check_for_user_or_create(user, password)
   User.create!(:login => user, :password => password, :password_confirmation => password, :email => "#{user}@test.com") unless User.find_by_login(user)
end

