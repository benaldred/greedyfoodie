Feature: Preview posts
  In order check my posts before they are published
  As an article writer
  I want to preview a post
  So that I can check it
  
  Scenario: preview a new post
    Given I am logged in as "admin" and wait
    And I am on the new post page
    When I fill in "post_title" with "my amazing blog post"
    And I fill in "post_body" with "some great content"
    And I press "Preview" to open new window
    Then I should see "my amazing blog post"
    And I should see "some great content"
    
  Scenario: preview an existing post 
    Given I am logged in as "admin" and wait
    And the following post:
      | title   | body             |
      | title foo | the amazing body |
    And I am on the post admin page
    When I follow "edit" and wait
    And I press "Preview" to open new window
    Then I should see "title foo"
    And I should see "the amazing body"
  
  
