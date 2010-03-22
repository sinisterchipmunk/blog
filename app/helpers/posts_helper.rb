module PostsHelper
  def recent_posts
    Post.find(:all, :limit => 10, :conditions => "NOT (publish_date IS NULL)", :order => 'publish_date DESC')
  end

  def publish_date(post)
    post.published? ? post.publish_date : "(Draft)"
  end

  # sets up any syntax highlighting and returns the result
  def post_body(post, options = { :line_numbers => :table, :css => :class })
    p = post.body.to_s
    # do some stuff with <br>'s when they should just be newlines
    rx = /(<pre>.*?)<br\s*\/>(.*?<\/pre>)/m
    p.gsub!(rx, "\\1\n\\2") while p =~ rx
    post.body.to_s.gsub(/<pre>\s*\[([^\s\[]+)\]\s*(.*?)\s*\[\/\1\]\s*<\/pre>/m) do |match|
      lang = $~[1]
      code = CGI::unescapeHTML($~[2]).gsub(/\&nbsp;/m, ' ').gsub(/<br[\s\t\n]*\/[\s\t\n]*>/m, "\n").strip
      CodeRay.scan(code, lang).div(options)
    end
  end
end
