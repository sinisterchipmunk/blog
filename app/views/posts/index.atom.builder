xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do

  xml.title   "Feed Name"
  xml.link    "rel" => "self", "href" => atom_feed_url
  xml.link    "rel" => "alternate", "href" => posts_url(:format => :atom)
  xml.id      url_for(:only_path => false, :controller => 'posts')
  xml.updated @posts.first.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @posts.any?
  xml.author  { xml.name "Author Name" }

  @posts.each do |post|
    xml.entry do
      xml.title   post.title
      xml.link    "rel" => "alternate", "href" => post_url(post)
      xml.id      post_url(post)
      xml.updated post.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name post.author.name }
      xml.summary "Post summary"
      xml.content "type" => "html" do
        xml.text! render(:partial => 'post_atom.html.erb', :locals => { :post => post })
      end
    end
  end
end
