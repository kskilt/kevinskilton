require "rails_helper"

RSpec.describe Post, type: :model do
  context "validation", :aggregate_failures do
    subject { build(:post) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_uniqueness_of(:slug) }

    it "requires a slug when the title is blank" do
      post = build(:post, title: nil, slug: nil)

      expect(post).not_to be_valid
      expect(post.errors[:slug]).to include("can't be blank")
    end
  end

  it "generates a slug from the title when blank" do
    post = create(:post, title: "Hello World", slug: "", status: :published, published_at: 1.day.ago)

    expect(post.slug).to eq("hello-world")
  end

  describe ".published" do
    let!(:draft_post) { create(:post, status: :draft, published_at: nil) }
    let!(:future_draft_post) { create(:post, status: :draft, published_at: 1.day.from_now) }
    let!(:published_post) { create(:post, status: :published, published_at: 1.day.ago) }

    it "includes published posts and excludes drafts" do
      expect(described_class.published).to contain_exactly(published_post)
      expect(described_class.published).not_to include(draft_post, future_draft_post)
    end
  end

  it "renders markdown in the body" do
    post = create(:post, status: :published, body: "Hello **markdown**", published_at: 1.day.ago)

    expect(post.rendered_body).to include("<strong>markdown</strong>")
  end
end
