class Tag < ActiveRecord::Base
  has_permalink :name, :update => true
  has_many :post_tags, :dependent => :destroy
  has_many :posts, :through => :post_tags
  validates_uniqueness_of :name
  validates_presence_of :name

  include PermalinkParam
end
