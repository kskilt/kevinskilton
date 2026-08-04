require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "generates a slug from the title when blank" do
    post = Post.create!(title: "Hello World", body: "content", published_at: Time.current)
    assert_equal "hello-world", post.slug
  end

  test "requires a body" do
    post = Post.new(title: "No Body", slug: "no-body")
    assert_not post.valid?
    assert_includes post.errors[:body], "can't be blank"
  end

  test "requires a unique slug" do
    duplicate = Post.new(title: "Different Title", slug: posts(:published).slug, body: "content")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:slug], "has already been taken"
  end

  test "published scope excludes drafts and future posts" do
    assert_includes Post.published, posts(:published)
    assert_not_includes Post.published, posts(:draft)
  end

  test "rendered_body converts markdown to html" do
    post = posts(:published)
    assert_includes post.rendered_body, "<strong>markdown</strong>"
  end
end
