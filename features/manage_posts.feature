Feature: Manage posts
  In order manage articles on my blog
  As an article writer
  I want to edit, delete and view existing blog posts
    
  Scenario: show a list of created posts with recent updated to the top
    Given the following posts:
      | title          | body             | created_at                | updated_at                |
      | a title        | the amazing body | 2009/06/24 14:10:27 +01:00 | 2009/06/24 14:10:27 +01:00 |
      | the best title | the amazing body | 2009/06/26 21:07:32 +01:00 | 2009/08/26 21:07:32 +01:00 |
      | a great post   | the amazing body | 2009/06/26 21:07:32 +01:00 | 2009/08/26 22:22:32 +01:00 |
  
    And I am logged in as "admin"
    And I am on the post admin page
    Then I should see the following posts:
    | title          | last updated            | created at   |
    | a great post   | 26 August 2009 at 22:22 | 26 June 2009 |
    | the best title | 26 August 2009 at 21:07 | 26 June 2009 |
    | a title        | 24 June 2009 at 14:10   | 24 June 2009 |
  
  Scenario: edit an existing post
    Given I am logged in as "admin"
    And the following post:
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
    Given I am logged in as "admin"
    And the following post:
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
    Given I am logged in as "admin"
    And the following post:
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
    Given I am logged in as "admin"
    And the following post:
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
    Given I am logged in as "admin"
    And the following posts:
      | title          | body             |updated_at                 |
      | a title        | the amazing body |2009/09/24 14:10:27 +01:00 |
      | a rubbish post | the crap body    |2009/08/26 21:07:32 +01:00 |
      | a great post   | the amazing body |2009/07/26 21:07:32 +01:00 |
    When I delete the 2nd post
    Then I should see the following posts:
    | title          | 
    | a title        |
    | a great post   | 
    

  
  
   
