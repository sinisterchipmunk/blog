class Post < ActiveRecord::Base
  include PermalinkParam
  belongs_to :author, :class_name => 'User'
  has_permalink :title, :update => true
  has_many :post_categories, :autosave => true, :dependent => :destroy
  has_many :categories, :through => :post_categories
  has_many :post_tags, :autosave => true, :dependent => :destroy
  has_many :tags, :through => :post_tags
  has_many :revisions, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_one :current_revision, :class_name => 'Revision'
  delegate :body, :to => :current_revision
  accepts_nested_attributes_for :current_revision
  accepts_nested_attributes_for :post_categories, :allow_destroy => true
  accepts_nested_attributes_for :post_tags, :allow_destroy => true
  validates_presence_of :title
  
  class << self
    def option(name, default = nil)
      class_inheritable_accessor(name)
      read_inheritable_attribute(name) || write_inheritable_attribute(name, default)
    end
  end
  
  option :summary_length, 128
  
  def draft?
    publish_date.blank?
  end

  def after_initialize
    self.current_revision ||= revisions.last || Revision.new(:number => 1)
  end
  
  def before_save
    self.permalink = nil # to be regenerated
    if valid?
      self.current_revision = Revision.new(current_revision.attributes.merge(:number => current_revision.number+1))
    end
  end

  def previous(include_drafts = false)
    c = include_drafts ? "" : sql_for_no_drafts
    @previous ||= Post.find(:first, :conditions => "(id != #{id}) AND publish_date < '#{publish_date}'#{c}", :order => "publish_date DESC")
  end

  def next(include_drafts = false)
    c = include_drafts ? "" : sql_for_no_drafts
    @next ||= Post.find(:first, :conditions => "(id != #{id}) AND publish_date > '#{publish_date}'#{c}", :order => "publish_date ASC")
  end
  
  def summary
    return nil unless body
    if body.length > Post.summary_length
      body[0..Post.summary_length]+"..."
    else
      body
    end
  end

  def sql_for_no_drafts
    " AND NOT (publish_date IS NULL)"
  end
  private :sql_for_no_drafts

  class << self
    def one_per_month
      hash = { }
      find(:all,
           #:select => "DISTINCT publish_date",
           :order => "publish_date DESC, updated_at",
           :conditions => 'NOT (publish_date IS NULL)').select do |p|
        (!hash[p.publish_date.strftime("%m%Y")]) && (hash[p.publish_date.strftime("%m%Y")] = 1)
      end
    end
  end
end
