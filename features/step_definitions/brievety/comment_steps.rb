Given /^I have left a comment$/ do
  Given 'I have published a post'
  Given 'I am logged in as a user'
  Given 'I am on the published post page'
  When  'I fill in "Leave a Message" with "This is a comment"'
  When  'I press "Post Comment"'
  Then  'I should not see "Sorry, you are not allowed to view this page"'
  Then  'I should be on the published post page'
  Then  'I should see "This is a comment"'
end