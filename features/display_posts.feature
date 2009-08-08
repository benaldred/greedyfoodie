Feature: Display blog Posts
  In order read and navigate the blog
  As a Blog reader
  I want to have posts displayed to me
  
  Scenario: show list of published posts, most recent first
    Given the following posts:
    | title       | body                   | created_at                | status     |
    | title six   | the amazing body six   | 2008/06/16 14:10:27 +0000 | published  |
    | title two   | the amazing body two   | 2009/07/28 21:07:32 +0000 | published  |
    | title three | the amazing body three | 2009/07/26 21:07:32 +0000 | published  |
    | title one   | the amazing body one   | 2009/08/24 14:10:27 +0000 | published  |
    | title five  | the amazing body five  | 2008/06/24 21:07:32 +0000 | published  |
    | title four  | the amazing body four  | 2009/06/28 21:07:32 +0000 | draft  |
    And I am on the index page
    Then I should see the following posts displayed:
      | title       | body                   | created_at     |
      | title one   | the amazing body one   | 24 August 2009 |
      | title two   | the amazing body two   | 28 July 2009   |
      | title three | the amazing body three | 26 July 2009   |
      | title five  | the amazing body five  | 24 June 2008   |
      | title six   | the amazing body six   | 16 June 2008   |
      
   Scenario: see all posts published a specified by year
    Given the following posts:
    | title       | body                   | created_at                | status     |
    | title six   | the amazing body six   | 2008/06/16 14:10:27 +0000 | published  |
    | title two   | the amazing body two   | 2009/07/28 21:07:32 +0000 | published  |
    | title three | the amazing body three | 2009/07/26 21:07:32 +0000 | published  |
    | title one   | the amazing body one   | 2009/08/24 14:10:27 +0000 | published  |
    | title five  | the amazing body five  | 2008/06/24 21:07:32 +0000 | published  |
    | title four  | the amazing body four  | 2009/06/28 21:07:32 +0000 | draft  |
    When I go to the page for "2009"
    Then I should see the following posts displayed:
      | title       | body                   | created_at     |
      | title one   | the amazing body one   | 24 August 2009 |
      | title two   | the amazing body two   | 28 July 2009   |
      | title three | the amazing body three | 26 July 2009   |
      
  Scenario: see all posts published a specified by year and month
   Given the following posts:
   | title       | body                   | created_at                | status     |
   | title six   | the amazing body six   | 2008/06/16 14:10:27 +0000 | published  |
   | title two   | the amazing body two   | 2009/07/28 21:07:32 +0000 | published  |
   | title three | the amazing body three | 2009/07/26 21:07:32 +0000 | published  |
   | title one   | the amazing body one   | 2009/08/24 14:10:27 +0000 | published  |
   | title five  | the amazing body five  | 2008/06/24 21:07:32 +0000 | published  |
   | title four  | the amazing body four  | 2009/06/28 21:07:32 +0000 | draft  |
   When I go to the page for "2009/07"
   Then I should see the following posts displayed:
     | title       | body                   | created_at     |
     | title two   | the amazing body two   | 28 July 2009   |
     | title three | the amazing body three | 26 July 2009   |

      
  
  
  




  
 