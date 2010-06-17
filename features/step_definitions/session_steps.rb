Given /^I am not logged in$/ do

end

Given /^I have an account$/ do
  User.create!(:email => "generic@example.com", :password => "password", :password_confirmation => "password",
               :display_name => "Generic Example", :username => "generic", :twitter_name => "generic")
end

Given /^I have an admin account$/ do
  @admin = 1
end

When /^I enter my credentials$/ do
  if @admin == 1
    fill_in "username", :with => "admin"
    fill_in "password", :with => "adminpw"
  else
    fill_in "username", :with => "generic"
    fill_in "password", :with => "password"
  end
  click_button "Log In"
end
