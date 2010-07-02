Feature: View All Posts
  As an end user
  In order to browse the history
  I want to see all posts

  Scenario: View all posts
    Given I have published a post
      And I am on the published post page
     When I follow "All Posts"
     Then I should be on the homepage
