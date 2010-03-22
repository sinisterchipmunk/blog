class AddPublishDateToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :publish_date, :datetime
  end

  def self.down
    remove_column :posts, :publish_date
  end
end
