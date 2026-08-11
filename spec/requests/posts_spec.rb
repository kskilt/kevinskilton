require "rails_helper"

RSpec.describe "Posts", type: :request do
  let!(:published_post) { create(:post, title: "Published", slug: "published-post", status: :published, published_at: 1.day.ago) }
  let!(:draft_post) { create(:post, title: "Draft", slug: "draft-post", status: :draft, published_at: nil, body: "Secret draft content.") }

  describe "GET /blog" do
    it "renders published posts and hides drafts" do
      get blog_path

      expect(response).to be_successful
      expect(response.body).to include(published_post.title)
      expect(response.body).not_to include(draft_post.title)
    end
  end

  describe "GET /blog.rss" do
    it "renders an RSS feed with published posts and hides drafts" do
      get blog_rss_path

      expect(response).to be_successful
      expect(response.media_type).to eq("application/rss+xml")
      expect(response.body).to include(published_post.title)
      expect(response.body).not_to include(draft_post.title)
      expect(response.body).not_to include(draft_post.body)
    end
  end

  describe "GET /posts/:slug" do
    it "renders a published post" do
      get post_path(published_post)

      expect(response).to be_successful
      expect(response.body).to include(published_post.title)
    end

    it "returns 404 for a draft post" do
      get post_path(draft_post)

      expect(response).to have_http_status(:not_found)
    end

    it "returns 404 for a missing slug" do
      get post_path("does-not-exist")

      expect(response).to have_http_status(:not_found)
    end
  end
end
