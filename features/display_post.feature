Feature: Display a blog post
  In order to read the blog post
  As a Blog reader
  I want to have a post displayed to me
  
  Scenario: show a post
    Given the following post:
      | title     | body             | created_at                | status    |
      | the title | the amazing body | 2009/06/24 14:10:27 +0000 | published |
    And I go to the post "/2009/06/the-title"
    Then I should see the following post displayed:
      | title     | body             | created_at   |
      | the title | the amazing body | 24 June 2009 |
      
  Scenario: show a post using textile
    Given the following post:
      | title     | body             | created_at                | status    |
      | the title | h3. subtitle using textile | 2009/06/24 14:10:27 +0000 | published |
    And I go to the post "/2009/06/the-title"
    Then I should see the following html in the post body:
      | tag     | content             |
      | h3 | subtitle using textile | 
      
  Scenario: show 404 when post exists but not published
    Given the following post:
      | title     | body             | created_at                | status |
      | the title | the amazing body | 2009/06/24 14:10:27 +0000 | draft  |
    And I go to the post "/2009/06/the-title"
    Then I should be on the 404 page
    
  Scenario: show 404 when post exists but the wrong year is given on url
    Given the following post:
      | title     | body             | created_at                | status |
      | the title | the amazing body | 2009/06/24 14:10:27 +0000 | published  |
    And I go to the post "/2010/06/the-title"
    Then I should be on the 404 page
