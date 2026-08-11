xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Kevin Skilton — Blog"
    xml.description "Posts from Kevin Skilton's blog"
    xml.link blog_url
    xml.language "en-us"

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.link post_url(post)
        xml.guid post_url(post)
        xml.pubDate post.published_at.to_fs(:rfc822) if post.published_at
        xml.description do
          xml.cdata! post.rendered_body
        end
      end
    end
  end
end
