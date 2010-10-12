module PostsHelper
  def recent_posts
    @recent_posts ||= Post.find(:all, :limit => 10, :conditions => "NOT (publish_date IS NULL)", :order => 'publish_date DESC')
  end

  def publish_date(post)
    post.published? ? post.publish_date : "(Draft)"
  end

  # sets up any markup and/or syntax highlighting and returns the result
  def post_body(post, options = { :line_numbers => :table, :css => :class, :brief => false })
    html = post.to_html(options)
    if (options[:brief])
      brief_post_body(post, html)
    else
      html
    end
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
