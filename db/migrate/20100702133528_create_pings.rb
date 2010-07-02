class CreatePings < ActiveRecord::Migration
  def self.up
    create_table :pings do |t|
      t.string :title
      t.string :url
      t.text :content
      
      t.references :post
      t.timestamps
    end
  end

  def self.down
    drop_table :pings
  end
end
