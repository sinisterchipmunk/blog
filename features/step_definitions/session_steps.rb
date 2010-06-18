Given /^I am not logged in$/ do
  delete user_session_path
  follow_redirect! if response.redirect?
end

Given /^I have an account$/ do
  User.find_by_email("generic@example.com") || begin
    u = User.new(:email => "generic@example.com",
                 :display_name => "Generic Example", :username => "generic", :twitter_name => "generic")
    u.password = u.password_confirmation = "Password01"
    u.save!
  end
end

Given /^I have an admin account$/ do
  @admin = 1
end

When /^I enter my credentials$/ do
  if @admin == 1
    fill_in "username", :with => "admin"
    fill_in "password", :with => "Admin01"
  else
    fill_in "username", :with => "generic"
    fill_in "password", :with => "Password01"
  end
  click_button "Sign In"
end
