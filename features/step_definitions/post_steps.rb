When /^I leave the publish date blank$/ do
  # nothing to do
end

When /^I enter post information$/ do
  fill_in "Title", :with => "Post Title"
  fill_in "Body", :with => "Post Body"
  click_button "post_submit"
end

When /^I set the publish date to "([^"]*)"$/ do |date|
  fill_in "Publish date", :with => date
end
