class CreatePostTags < ActiveRecord::Migration
  def self.up
    create_table :post_tags do |t|
      t.integer :post_id
      t.integer :tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :post_tags
  end
end
