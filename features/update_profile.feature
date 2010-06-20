Feature: Update user profile
  As a user
  In order to change my user details
  I want to update my profile

  Scenario: Update regular user profile, and then verify changes
    Given I am logged in as a user
      And I am on the homepage
    When I follow "Edit Profile"
      And I fill in "Email" with "generic2@example.com"
      And I fill in "Twitter name" with "generic2"
      And I press "Save changes"
    Then I should see "Your changes have been saved."
    # Verification
    When I follow "Edit Profile"
    Then I should see a text field with value "generic2@example.com"
      And I should see a text field with value "generic2"

  Scenario: Update password should not log the user out
    Given I am logged in as a user
      And I am on the homepage
    When I follow "Edit Profile"
      And I fill in "Password" with "genericpw3"
      And I fill in "Password confirmation" with "genericpw3"
      And I press "Save changes"
    Then I should not see "You must be signed in to view this page."
      And I should not see "You have been signed out."
      And I should see "Your changes have been saved."
    