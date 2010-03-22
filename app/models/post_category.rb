class PostCategory < ActiveRecord::Base
  belongs_to :category
  belongs_to :post
  accepts_nested_attributes_for :category
end
