Feature: Manage posts
  In order manage articles on my blog
  As an article writer
  I want to create draft blog posts
  So that I can write posts
  
  Scenario: create a new draft post
    Given I am on the new post page
    When I fill in "post_title" with "my amazing blog post"
    And I fill in "post_body" with "some great content"
    And I press "Save Draft"
    Then I should be on the edit page for "my-amazing-blog-post"
    And the "Title" field should contain "my amazing blog post"
    And the "Body" field should contain "some great content"
    And I should see "Status: draft"
    And I should see an "Update Post" button
    And I should see a "Publish" button
    
  Scenario: show a list of created posts
    Given the following posts:
      | title          | body             |
      | a title        | the amazing body |
      | a rubbish post | the crap body    |
      | a great post   | the amazing body |
    And I am on the post admin page
    Then I should see the following posts:
    | title          | created at       |
    | a title        | the amazing body |
    | a great post   | the amazing body |
  

  Scenario: create a new post and publish
    Given I am on the new post page
    When I fill in "post_title" with "my amazing blog post"
    And I fill in "post_body" with "some great content"
    And I press "Publish"
    Then I should be on the edit page for "my-amazing-blog-post"
    And I should see "Status: published"
    And I should see an "Update Post" button
    And I should not see a "Publish" button
    
  Scenario: edit an existing post
    Given the following post:
      | title   | body             |
      | a title | the amazing body |
    And I am on the post admin page
    When I follow "edit"
    And I fill in "title" with "another title"
    And I fill in "body" with "different text"
    And I press "Update Post"
    Then I should be on the edit page for "another-title"
    Then the "title" field should contain "another title"
    And the "body" field should contain "different text"
    
  Scenario: Delete a post
    Given the following posts:
      | title          | body             |
      | a title        | the amazing body |
      | a rubbish post | the crap body    |
      | a great post   | the amazing body |
    When I delete the 2nd post
    Then I should see the following posts:
    | title          | body             |
    | a title        | the amazing body |
    | a great post   | the amazing body |

  
  
   
