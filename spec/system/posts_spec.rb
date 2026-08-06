require "rails_helper"

RSpec.describe "Posts", type: :system do
  let!(:published_post) { create(:post, title: "Published", slug: "published-post", status: :published, published_at: 1.day.ago) }
  let!(:draft_post) { create(:post, title: "Draft", slug: "draft-post", status: :draft, published_at: nil) }

  it "shows published posts on the blog page" do
    visit blog_path

    expect(page).to have_text(published_post.title)
    expect(page).not_to have_text(draft_post.title)
  end

  it "shows a published post page" do
    visit post_path(published_post)

    expect(page).to have_selector("h1", text: published_post.title)
  end
end
