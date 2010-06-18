Given /^I am not logged in$/ do

end

Given /^I have an account$/ do
  u = User.new(:email => "generic@example.com",
               :display_name => "Generic Example", :username => "generic", :twitter_name => "generic")
  u.password = u.password_confirmation = "Password01"
  u.save!
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

Given /^I am logged in as an admin$/ do
  Given 'I have an admin account'
  Given 'I am on the homepage'
  When 'I follow "Log In"'
  When 'I enter my credentials'
  Then 'I should see "Signed in successfully."'
end