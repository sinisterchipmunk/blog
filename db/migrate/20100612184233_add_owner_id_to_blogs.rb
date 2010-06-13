class AddOwnerIdToBlogs < ActiveRecord::Migration
  def self.up
    add_column :blogs, :owner_id, :integer
    
    owner = User.first
    Blog.all.each { |b| b.update_attribute(:owner_id, owner.id) }
  end

  def self.down
    remove_column :blogs, :owner_id
  end
end
