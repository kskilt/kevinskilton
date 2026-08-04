class Post < ApplicationRecord
  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :body, presence: true

  scope :published, -> { where.not(published_at: nil).where(published_at: ..Time.current) }
  scope :recent_first, -> { order(published_at: :desc) }

  def to_param
    slug
  end

  def rendered_body
    markdown_renderer.render(body).html_safe
  end

  private

  def generate_slug
    self.slug = title.parameterize
  end

  def markdown_renderer
    @markdown_renderer ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new(filter_html: false, hard_wrap: true),
      fenced_code_blocks: true,
      tables: true,
      autolink: true
    )
  end
end
