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
    Then the "post_title" field should contain "my amazing blog post"
    And the "post_body" field should contain "some great content"
    And I should see "Status: Draft"
