require "application_system_test_case"

class PostsTest < ApplicationSystemTestCase
  test "visiting the homepage shows published posts" do
    visit root_url

    assert_text posts(:published).title
    assert_no_text posts(:draft).title
  end

  test "viewing a single post" do
    visit post_url(posts(:published))

    assert_selector "h1", text: posts(:published).title
  end
end
