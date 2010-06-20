Feature: Create comment
  In order to encourage the author
  As a user
  I want to leave a comment
  
  Scenario: Add a comment
    Given I have published a post
      And I am logged in as a user
      And I am on the published post page
    When  I fill in "Leave a Message" with "This is a comment"
      And I press "Post Comment"
    Then  I should not see "Sorry, you are not allowed to view this page"
      And I should be on the published post page
      And I should see "This is a comment"
      And I should see "1 comment"
      And I should not see "1 comments"
    
  Scenario: Invalid comment (no body)
    Given I have published a post
      And I am logged in as a user
      And I am on the published post page
    When I press "Post Comment"
    Then I should be on the post comments page
      And I should see "Body can't be blank"
