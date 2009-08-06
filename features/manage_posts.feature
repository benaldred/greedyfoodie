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
    
  Scenario: create a new draft post with a title that already exists
    Given the following post:
      | title   | body             |
      | a title | the amazing body |
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
    
  Scenario: show a list of created posts
    Given the following posts:
      | title        | body             | created_at                |
      | a title      | the amazing body | 2009/06/24 14:10:27 +0000 |
      | the best title | the amazing body | 2009/06/26 21:07:32 +0000 |
      | a great post | the amazing body | 2009/06/26 21:07:32 +0000 |
    And I am on the post admin page
    Then I should see the following posts:
    | title          | created at       |
    | a great post        | 26 June 2009 |
    | a title   | 24 June 2009 |
  

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
    And I fill in "body" with "the amazing body and some more text"
    And I press "Update Post"
    Then I should be on the edit page for "a-title"
    Then the "title" field should contain "a title"
    And the "body" field should contain "the amazing body and some more text"
  
  Scenario: edit an existing post, changing the title
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
    
  Scenario: edit an existing post, changing the title to one that already exists
    Given the following post:
      | title   | body             |
      | a title foo | the amazing body |
      | a title | the amazing body |
    And I am on the post admin page
    When I follow "edit"
    And I fill in "title" with "another title"
    And I fill in "body" with "different text"
    And I press "Update Post"
    Then I should be on the edit page for "another-title"
    Then the "title" field should contain "another title"
    And the "body" field should contain "different text"
    
  Scenario: publish an existing post
    Given the following post:
      | title   | body             | status |
      | a title | the amazing body | draft  |
    And I am on the post admin page
    When I follow "edit"
    And I press "Publish"
    Then I should be on the edit page for "a-title"
    Then the "title" field should contain "a title"
    And the "body" field should contain "the amazing body"
    And I should see "Status: published"
    
  Scenario: Delete a post
    Given the following posts:
      | title          | body             |
      | a title        | the amazing body |
      | a rubbish post | the crap body    |
      | a great post   | the amazing body |
    When I delete the 2nd post
    Then I should see the following posts:
    | title          |
    | a great post   | 
    | a title        | 
    

  
  
   
