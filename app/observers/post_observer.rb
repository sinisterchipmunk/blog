class PostObserver < ActiveRecord::Observer
  def after_create(post)
  end

  def after_save(post)
    # FIXME comment.post should respond_to blog, but it doesn't
    Google::Blogsearch::Ping.new("Thoughts in Computation",
                                 ActionController::Integration::Session.new.rss_feed_path,
                                 :updated => ActionController::Integration::Session.new.post_path(post))
    Rails.logger.info "Pinged google."
  end
end
