Feature: Create post
  In order to attract people to my blog
  As a blog owner (user)
  I want to create a post

  Scenario: Create DRAFT post from new post page while logged in
    Given I am logged in as an admin
    When I go to the new post page
      And I leave the publish date blank
      And I enter post information
    Then I should see "Post was successfully created."
    
  Scenario: Create PUBLISHED post from new post page while logged in
    Given I am logged in as an admin
    When I go to the new post page
      And I set the publish date to "June 5, 2010"
      And I enter post information
    Then I should see "Post was successfully created."
    
  Scenario: Follow link while logged in
    Given I am logged in as an admin
      And I am on the homepage
    When I follow "Create"
    Then I should see "New post"
    
  Scenario: Follow link while not logged in
    Given I am not logged in
    When I go to the homepage
    Then I should not see "Recent Posts [Create]"
    
  Scenario: Go directly to location while not logged in
    Given I am not logged in
    When I go to the new post page
    Then I should see "Sorry, you are not allowed to view this page"
    