Given /^I have published a post$/ do
  Given 'I am logged in as an admin'
  When 'I go to the new post page'
  When 'I set the publish date to "June 5, 2010"'
  When 'I enter post information'
  Then 'I should see "Post was successfully created."'
end
