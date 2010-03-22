class Category < ActiveRecord::Base
  has_permalink :name, :update => true
  has_many :post_categories, :dependent => :destroy
  has_many :posts, :through => :post_categories
  validates_uniqueness_of :name
  validates_presence_of :name

  include PermalinkParam
end
