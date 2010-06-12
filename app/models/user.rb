class User < ActiveRecord::Base
  has_many :posts, :foreign_key => 'author_id'
  has_many :user_roles, :dependent => :destroy
  has_many :roles, :through => :user_roles
  has_many :comments, :foreign_key => 'author_id'

  validates_presence_of :display_name

  acts_as_authentic do |config|
    config.openid_required_fields = [:nickname, :email]
  end

  def role_symbols
    roles.map do |role|
      role.name.underscore.to_sym
    end
  end

  def name; display_name; end
  
  private
  def map_openid_registration(registration)
    self.username = registration[:nickname] if username.blank?
    self.email    = registration[:email]    if email.blank?
  end
end
