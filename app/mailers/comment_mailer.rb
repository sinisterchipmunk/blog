class CommentMailer < ActionMailer::Base
  
  def new_comment(comment)
    recipients comment.post.author.email
    from "system@thoughtsincomputation.com"
    subject "New Comment"
    content_type "text/html"
    body :comment => comment
  end
end
