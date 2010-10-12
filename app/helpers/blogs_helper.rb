module BlogsHelper
  def blog_title(caption = "")
    caption ||= ""
    r = caption.gsub(/<.*>/, '')
    title = "#{blog.name} with #{blog.owner.name}"
    if !r.blank?
      title.concat " - #{r}"
    end
    title
  end
end
