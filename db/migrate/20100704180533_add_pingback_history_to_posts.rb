class AddPingbackHistoryToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :pingback_history, :text
  end

  def self.down
    remove_column :posts, :pingback_history
  end
end
