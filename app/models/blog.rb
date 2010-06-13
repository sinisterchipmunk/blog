class Blog < ActiveRecord::Base
  validates_presence_of :name
  belongs_to :owner, :class_name => "User"
end
