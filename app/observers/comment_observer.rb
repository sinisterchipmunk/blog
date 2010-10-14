class CommentObserver < ActiveRecord::Observer
  
  def after_create(comment)
    CommentMailer.deliver_new_comment(comment)
  end
  
  def after_save(comment)
    # FIXME comment.post should respond_to blog, but it doesn't
    Google::Blogsearch::Ping.new("Thoughts in Computation",
                                 ActionController::Integration::Session.new.rss_feed_path,
                                 :updated => ActionController::Integration::Session.new.post_path(comment.post))
    Rails.logger.info "Pinged google."
  end
end
