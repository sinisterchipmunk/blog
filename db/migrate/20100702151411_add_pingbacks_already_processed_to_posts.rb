class AddPingbacksAlreadyProcessedToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :pingbacks_already_processed, :boolean
  end

  def self.down
    remove_column :posts, :pingbacks_already_processed
  end
end
