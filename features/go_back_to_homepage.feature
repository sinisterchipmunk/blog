Feature: Go back to homepage
  
  Scenario: Not logged in
    Given I am on the categories page
    When I follow "My Blog"
    Then I should be on the homepage
