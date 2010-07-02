class CommentObserver < ActiveRecord::Observer
  
  def after_create(comment)
    CommentMailer.deliver_new_comment(comment)
  end
end
