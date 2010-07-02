class PingbackMailer < ActionMailer::Base
  def pingback(ping)
    recipients ping.post.author.email
    from "system@thoughtsincomputation.com"
    subject "New Pingback"
    content_type "text/html"
    body :pingback => ping
  end
end
