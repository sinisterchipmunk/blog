Given /^I have signed in$/ do
  Given "I am not logged in"
  Given 'I am on the new user session page'
  When "I enter my credentials"
  Then 'I should see "Signed in successfully."'
end

Given /^I am logged in as an admin$/ do
  Given 'I have an admin account'
  Given 'I have signed in'
end

Given /^I am logged in as a guest/ do
  Given "I have an account"
  Given "I have signed in"
end
