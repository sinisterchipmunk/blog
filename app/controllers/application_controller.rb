# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # before_filter :no_tweetbacks! # something's flaky with them, disabled until they're working properly again.
  before_filter { |c| Authorization.current_user = c.current_user }
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout 'blog'

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation, :openid_identifier

#  helper_method :current_user
#  
#
#  def current_user_session
#    return @current_user_session if defined?(@current_user_session)
#    @current_user_session = UserSession.find
#  end
#
#  def current_user
#    return @current_user if defined?(@current_user)
#    @current_user = current_user_session && current_user_session.record
#  end

  protected
  def filter_posts(posts)
    if permitted_to?(:edit, :posts)
      # Move drafts to front of list so user doesn't lose track of them.
      drafts = posts.select { |p| p.draft? }
      posts.reject! { |p| p.draft? }
      posts = drafts + posts
    else
      # Remove drafts if current user isn't allowed to edit them.
      posts.reject! { |p| p.draft? }
    end
    posts
  end

  def permission_denied
    flash[:error] = "Sorry, you are not allowed to view this page"
    redirect_to root_url
  end

  def no_tweetbacks!
    @tweetbacks = false
  end

  class << self
    def no_tweetbacks!
      before_filter :no_tweetbacks!
    end
  end
end
