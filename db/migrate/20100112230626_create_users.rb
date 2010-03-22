class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :display_name
      t.string :username, :default => nil, :null => true
      t.string :email
      t.string :crypted_password, :default => nil, :null => true
      t.string :password_salt, :default => nil, :null => true
      t.string :persistence_token
      t.string :openid_identifier

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
