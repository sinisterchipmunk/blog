xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       "#{blog.name} - RSS Feed"
    xml.link        root_url
    xml.pubDate     CGI.rfc1123_date @posts.first.updated_at if @posts.any?
    xml.description "A Blog"

    @posts.each do |post|
      xml.item do
        xml.title       post.title
        xml.link        post_url(post)
        xml.description post_body(post)
        xml.pubDate     CGI.rfc1123_date post.updated_at
        xml.guid        post_url(post)
        xml.author      "#{post.author.name} &lt;#{post.author.email}&gt;"
      end
    end
  end
end
