When /^I create a post with an image at "([^"]*)"$/ do |location|
  When 'I go to the new post page'
  When 'I set the publish date to "June 5, 2010"'
  fill_in "Title", :with => "Post Title"
  fill_in "post_body", :with => "here is an image: <img src=\"#{location}\" />"
  click_button "post_submit"
  Then 'I should see "Post was successfully created."'
end

Then /^there should be images in the database$/ do
  Image.count.should_not == 0
end

Then /^the post's images should be reassigned$/ do
  Post.last.body.should == "here is an image: <img src=\"http://www.example.com/images/#{Image.last.to_param}\" />"
end

Then /^there should be an image called "([^"]*)"$/ do |name|
  visit image_path(Image.find_by_name(name).to_param)
  response.content_type.should == "image/png"
end
