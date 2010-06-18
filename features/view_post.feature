Feature: View post
  As a user
  In order to garner some valuable information
  I want to view one of the blog's posts

  Background:
    Given I have published a post
    
  Scenario: View post while logged in as admin
    Given I am logged in as an admin
    When  I am on the published post page
    Then  I should see "Post Title"
      And I should see "Post Body"

  Scenario: View post while logged in a user
    Given I am logged in
    When  I am on the published post page
    Then  I should see "Post Title"
      And I should see "Post Body"

  Scenario: View post while not logged in
    Given I am not logged in
    When  I am on the published post page
    Then  I should see "Post Title"
      And I should see "Post Body"

  Scenario: View post with comments while not logged in
    Given I have left a comment
    Given I am not logged in
    When  I am on the published post page
    Then  I should see "Post Title"
      And I should see "Post Body"
    