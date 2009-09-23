Feature: Create posts
  In order create articles on my blog
  As an article writer
  I want to create draft blog posts and publish them
  
  Scenario: create a new draft post
    Given I am on the new post page
    And I am logged in as "admin"
    When I fill in "post_title" with "my amazing blog post"
    And I fill in "post_body" with "some great content"
    And I press "Save Draft"
    Then I should be on the edit page for "my-amazing-blog-post"
    And the "Title" field should contain "my amazing blog post"
    And the "Body" field should contain "some great content"
    And I should see "Status: draft"
    And I should see an "Update Post" button
    And I should see a "Publish" button
    
  Scenario: create a new draft post with a title that already exists
    Given the following post:
      | title   | body             |
      | a title | the amazing body |
    And I am logged in as "admin"
    And I am on the new post page
    When I fill in "post_title" with "a title"
    And I fill in "post_body" with "some great content"
    And I press "Save Draft"
    Then I should be on the edit page for "a-title-2"
    And the "Title" field should contain "a title"
    And the "Body" field should contain "some great content"
    And I should see "Status: draft"
    And I should see an "Update Post" button
    And I should see a "Publish" button

  Scenario: create a new post and publish
    Given I am logged in as "admin"
    And I am on the new post page
    When I fill in "post_title" with "my amazing blog post"
    And I fill in "post_body" with "some great content"
    And I press "Publish"
    Then I should be on the edit page for "my-amazing-blog-post"
    And I should see "Status: published"
    And I should see an "Update Post" button
    And I should not see a "Publish" button
    


  
  
   
