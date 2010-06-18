Feature: Log in
  
  Scenario: Log in as an admin
    Given I have an admin account
      And I am on the homepage
    When I follow "Log In"
      And I enter my credentials
    Then I should see "Signed in successfully."

  Scenario: Log in as a regular user
    Given I have an account
      And I am on the homepage
    When I follow "Log In"
      And I enter my credentials
    Then I should see "Signed in successfully."
    
  Scenario: Log in invalid
    Given I am on the homepage
    When I follow "Log In"
      And I enter my credentials
    Then I should see "Credentials were not valid."
    