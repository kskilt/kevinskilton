require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "index lists published posts but not drafts" do
    get root_url
    assert_response :success
    assert_match posts(:published).title, response.body
    assert_no_match posts(:draft).title, response.body
  end

  test "show renders a published post" do
    get post_url(posts(:published))
    assert_response :success
    assert_match posts(:published).title, response.body
  end

  test "show 404s for a draft post" do
    get post_url(posts(:draft))
    assert_response :not_found
  end

  test "show 404s for an unknown slug" do
    get post_url("does-not-exist")
    assert_response :not_found
  end
end
