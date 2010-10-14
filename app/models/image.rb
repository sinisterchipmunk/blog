class Image < ActiveRecord::Base
  validates_presence_of :data
  validates_presence_of :name
  validates_presence_of :content_type
  
  validate do |record|
    if !record.content_type['image']
      record.errors.add_to_base("Only image formats are accepted")
    end
  end
  
  def to_param
    "#{id}-#{name.dehumanize.underscore}"
  end
end
