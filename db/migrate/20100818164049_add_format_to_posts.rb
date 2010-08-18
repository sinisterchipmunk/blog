class AddFormatToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :format, :string, :default => 'html'
  end

  def self.down
    remove_column :posts, :format
  end
end
