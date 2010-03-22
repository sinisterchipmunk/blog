# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
Blog.create(:name => 'My Blog')

admin = Role.create([{:name => 'admin'}, {:name => 'moderator'}, {:name => 'author'}])

(u = User.new(:display_name => 'Your Name',
         :email => 'your@email.net',
         :username => 'admin',
         :password => 'adminpw',
         :password_confirmation => 'adminpw',
         :openid_identifier => nil
        )).save
u.roles << admin
