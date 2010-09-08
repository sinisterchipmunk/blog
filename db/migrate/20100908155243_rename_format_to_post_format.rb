class RenameFormatToPostFormat < ActiveRecord::Migration
  # to avoid naming clashes
  def self.up
    rename_column :posts, :format, :post_format
  end

  def self.down
    rename_column :posts, :post_format, :format
  end
end
