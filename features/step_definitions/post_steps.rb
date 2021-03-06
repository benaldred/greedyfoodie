Given /^the following posts?:$/ do |table|
  table.hashes.each do |hash|
    post = Post.create!(hash)
    # we need to override the updated_at with the values supplied
    if hash.include?('updated_at')
      post.set_updated_at(hash['updated_at'])
      # save without running the set_timestamps
      post.save_without_callbacks
    end
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
      response.should have_selector("table > tbody > tr:nth-child(#{i+1}) > td:nth-child(#{j+1})") { |td|
        text = td.inner_text.strip.chomp
        text.should == cell
      }
    end
  end
end

# look through a list of posts
Then /^I should see the following posts displayed:$/ do |posts|
  posts.hashes.each_with_index do |row, i|
    response.should have_selector(".post:nth-of-type(#{i+1})") { |post|
      post.should have_selector("h2", :content => row['title'])
      post.should contain(row['body'])
      post.should contain(row['created_at'])
    }
  end
end

Then /^I should see the following post displayed:$/ do |post|
  post = post.hashes[0]
  response.should have_selector(".post:nth-of-type(1)") { |item|
    item.should have_selector("h1", :content => post['title'])
    item.should contain(post['body'])
    item.should contain(post['created_at'])
  }
end

Then /^I should not see the any posts displayed$/ do
  response.should_not have_selector(".post:nth-of-type(1)")
end

Then /^I should only see "([^\"]*)" posts displayed$/ do |i|
  response.should_not have_selector(".post:nth-of-type(#{i.to_i+1})")
end


Then /^I should see the title "([^\"]*)"$/ do |title|
  response.should have_selector("h1", :content => title)
end