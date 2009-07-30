Feature: Preview posts
  In order check my posts before they are published
  As an article writer
  I want to preview a post
  So that I can check it
  
  Scenario: preview a new post
    Given I am on the new post page
    When I fill in "post_title" with "my amazing blog post"
    And I fill in "post_body" with "some great content"
    And I press "Preview"
    Then I should be on the preview page for "my-amazing-blog-post"
    And I should see the title "my amazing blog post"
    And I should see "some great content"
    
  Scenario: preview an existing post
    Given the following post:
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
  
  
  