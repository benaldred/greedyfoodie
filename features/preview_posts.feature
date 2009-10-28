Feature: Preview posts
  In order check my posts before they are published
  As an article writer
  I want to preview a post
  So that I can check it
    
  Scenario: preview an existing post
    Given I am logged in as "admin"
    And the following post:
      | title   | body             |
      | a title | the amazing body |
    And I am on the post admin page
    When I follow "edit"
    And I fill in "title" with "another title"
    And I fill in "body" with "different text"
    And I press "Preview"
    Then I should be on the preview page for "another-title"
    And I should see the title "another title"
    And I should see "different text"
  
  
  