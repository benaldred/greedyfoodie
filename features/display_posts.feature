Feature: Display blog Posts
  In order read and navigate the blog
  As a Blog reader
  I want to have posts displayed to me
  
  Scenario: show list of posts, most recent first, limited to 5
    Given the following posts:
      | title       | body                   | created_at                | status     |
      | title six   | the amazing body six   | 2009/06/24 14:10:27 +0000 | published  |
      | title two   | the amazing body two   | 2009/07/28 21:07:32 +0000 | published  |
      | title three | the amazing body three | 2009/07/26 21:07:32 +0000 | published  |
      | title one   | the amazing body one   | 2009/08/24 14:10:27 +0000 | published  |
      | title five  | the amazing body five  | 2009/06/26 21:07:32 +0000 | published  |
      | title four  | the amazing body four  | 2009/06/28 21:07:32 +0000 | published  |
    And I am on the index page
    Then I should see the following posts displayed:
      | title       | body                   | created_at     |
      | title one   | the amazing body one   | 24 August 2009 |
      | title two   | the amazing body two   | 28 July 2009   |
      | title three | the amazing body three | 26 July 2009   |
      | title four  | the amazing body four  | 28 June 2009   |
      | title five  | the amazing body five  | 26 June 2009   |
    And I should only see "5" posts displayed                   
  
  Scenario: only show published posts
    Given the following posts:
      | title     | body             | created_at                | status |
      | the title | the amazing body | 2009/06/24 14:10:27 +0000 | draft  |
    And I am on the index page
    Then I should not see the any posts displayed              
  
  
  




  
 