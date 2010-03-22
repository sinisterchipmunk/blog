class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.string :permalink
      t.boolean :show_updated
      t.boolean :published

      t.references :author
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
