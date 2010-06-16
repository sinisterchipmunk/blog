class Comment < ActiveRecord::Base
  belongs_to :author, :class_name => 'User'
  belongs_to :post
  
  validates_presence_of :body
end
