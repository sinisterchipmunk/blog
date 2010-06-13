xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   "#{blog.name} - ATOM Feed"
  xml.link    "rel" => "self", "href" => root_url
  xml.link    "rel" => "alternate", "href" => posts_url
  xml.id      root_url
  xml.updated @posts.first.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @posts.any?
  xml.author  { xml.name blog.owner.name }

  @posts.each do |post|
    xml.entry do
      xml.title   post.title
      xml.link    "rel" => "alternate", "href" => post_url(post)
      xml.id      post_url(post)
      xml.updated post.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name post.author.name }
      xml.summary post.summary
      xml.content "type" => "html" do
        xml.text! render(:partial => 'post_atom.html.erb', :locals => { :post => post })
      end
    end
  end
end
