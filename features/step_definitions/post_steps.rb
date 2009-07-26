Given /^the following posts?:$/ do |table|
  table.hashes.each do |hash|
    Post.create!(hash)
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) post$/ do |pos|
  visit admin_posts_url
  within("table > tbody > tr:nth-child(#{pos.to_i})") do
    click_button "delete"
  end
end

Then /^I should see the following posts?:$/ do |posts|
  posts.rows.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tbody > tr:nth-child(#{i+1}) > td:nth-child(#{j+2})") { |td|
        td.inner_text.should == cell
      }
    end
  end
end


