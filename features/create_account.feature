Feature: Create new account
  As a visitor
  In order to access account-only functions such as leaving comments
  I want to create an account

  Scenario: Create new account
    Given I am not logged in
      And I am on the homepage
    When I follow "Register"
      And I fill in "Display name" with "Colin"
      And I fill in "Username" with "colin"
      And I fill in "Password" with "Testtest1"
      And I fill in "Password confirmation" with "Testtest1"
      And I press "Save changes"
    Then I should see "Your account has been created."
      And I should not see "Log In"
      And I should see "Log Out"
    