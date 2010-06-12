Before do
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
end
