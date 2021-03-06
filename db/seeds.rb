# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
admin = Role.create!(:name => 'admin')
moderator = Role.create!(:name => 'moderator')
author = Role.create!(:name => 'author')

user = User.new(:display_name => 'Your Name',
         :email => 'your@email.net',
         :username => 'admin',
         :openid_identifier => nil
        )
user.password = user.password_confirmation = 'Admin01'
user.roles << admin << moderator << author
user.save!

if Blog.count > 0
  b = Blog.first
  b.owner = user
  b.save!
else
  Blog.create!(:name => 'My Blog', :owner => user)
end
