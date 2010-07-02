module PostsHelper
  def recent_posts
    @recent_posts ||= Post.find(:all, :limit => 10, :conditions => "NOT (publish_date IS NULL)", :order => 'publish_date DESC')
  end

  def publish_date(post)
    post.published? ? post.publish_date : "(Draft)"
  end

  # sets up any syntax highlighting and returns the result
  def post_body(post, options = { :line_numbers => :table, :css => :class, :brief => false })
    p = post.body.to_s
    # do some stuff with <br>'s when they should just be newlines
    rx = /(<pre>.*?)<br\s*\/>(.*?<\/pre>)/m
    p.gsub!(rx, "\\1\n\\2") while p =~ rx
    body = post.body.to_s.gsub(/<pre>\s*\[([^\s\[]+)\]\s*(.*?)\s*\[\/\1\]\s*<\/pre>/m) do |match|
      lang = $~[1]
      code = CGI::unescapeHTML($~[2]).gsub(/\&nbsp;/m, ' ').gsub(/<br[\s\t\n]*\/[\s\t\n]*>/m, "\n").strip
      CodeRay.scan(code, lang).div(options)
    end
    options[:brief] ? brief_post_body(post, body) : body
  end
  
  # You can use the body argument to override the post's body. Useful if you've applied syntax highlighting, etc.
  def brief_post_body(post, body = post.body)
    if body =~ /\A.*?<\/p>\s*<p>.*?(<\/p>\s*<p>)/m
      offset = $~.offset(1)
      body[0...offset[0]] + ".. " + link_to("(Read More...)", post_path(post)) + "</p>"
    else
      body
    end
  end

  def link_to_new_post_with_categories(post)
    link_to "Create", :controller => 'posts', :action => 'new',
            'post[category_ids]' => @new_post_for_category.post_categories.collect { |i| i.category_id }
  end
end
