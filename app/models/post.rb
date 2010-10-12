class Post < ActiveRecord::Base
  include PermalinkParam
  belongs_to :author, :class_name => 'User'
  has_permalink :title, :update => true
  has_many :post_categories, :autosave => true, :dependent => :destroy
  has_many :categories, :through => :post_categories
  has_many :post_tags, :autosave => true, :dependent => :destroy
  has_many :tags, :through => :post_tags
  has_many :revisions, :dependent => :destroy
  has_many :comments, :dependent => :destroy, :order => "created_at DESC"
  has_many :pingbacks, :class_name => "Ping"
  has_one :current_revision, :class_name => 'Revision'
  delegate :body, :to => :current_revision
  accepts_nested_attributes_for :current_revision
  accepts_nested_attributes_for :post_categories, :allow_destroy => true
  accepts_nested_attributes_for :post_tags, :allow_destroy => true
  validates_presence_of :title
  serialize :pingback_history, Array
  
  class << self
    def option(name, default = nil)
      class_inheritable_accessor(name)
      read_inheritable_attribute(name) || write_inheritable_attribute(name, default)
    end
  end
  
  option :summary_length, 128
  
  def post_format
    x = super
    new_record? || x.blank? ? 'rdoc' : x
  end
  
  def pingback_history
    h = super
    return h if h
    self.pingback_history = []
  end
  
  def pingbacks_should_be_processed?
    !draft?
  end
  
  def draft?
    publish_date.blank?
  end
  
  # there should always be a current revision.
  alias _current_revision current_revision
  def current_revision
    if _current_revision
      _current_revision.number ||= 1
      return _current_revision
    end
    
    self.current_revision = revisions.last || Revision.new(:number => 1)
    _current_revision
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
  
  def to_html(options = { :line_numbers => :table, :css => :class })
    post = self
    if post.post_format == "html"
      body = post.body.to_s
    else
      body = case post.post_format
        when 'rdoc' then
          GitHub::Markup.render("#{post.permalink}.rdoc", post.body.to_s)
        else post.body.to_s
      end
    end
    colorize(body, options)
  end
  
  private
  
  def colorize(body, options)
    p = body.dup
    # do some stuff with <br>'s when they should just be newlines
    rx = /(<pre>.*?)<br\s*\/>(.*?<\/pre>)/m
    p.gsub!(rx, "\\1\n\\2") while p =~ rx
    body.gsub(/<pre>\s*\[([^\s\[]+)\](\n|)(.*?)\s*\[\/\1\]\s*<\/pre>/m) do |match|
      lang = $~[1]
      code = $~[3]
      # remove preceding indentation, if any
      indentation = code =~ /[^\s]/
      code.gsub!(/^#{Regexp::escape " "*indentation}/, '')
      # remove forced line breaks, which are inserted by tiny_mce.
      code = CGI::unescapeHTML(code).gsub(/\&nbsp;/m, ' ').gsub(/<br[\s\t\n]*\/[\s\t\n]*>/m, "\n")#.strip
      CodeRay.scan(code, lang).div(options)
    end
  end

  class << self
    public
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
