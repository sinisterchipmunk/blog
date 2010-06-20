Then /^I should see a text field with value "([^\"]*)"$/ do |value|
  response.should have_selector("input", :value => value)
end
