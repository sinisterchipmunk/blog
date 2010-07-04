class Image < ActiveRecord::Base
  validates_presence_of :data
  validates_presence_of :name
  validates_presence_of :content_type
  
  def to_param
    "#{id}-#{name.dehumanize}"
  end
end
