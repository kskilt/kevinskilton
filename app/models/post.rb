class Post < ApplicationRecord
  before_validation :generate_slug, if: -> { slug.blank? && title.present? }
  before_validation :set_published_at, if: -> { published? && published_at.blank? }

  enum :status, { draft: 0, published: 1 }

  TECHNOLOGY_PILLS = YAML.load_file(Rails.root.join("config/technology_pills.yml")).transform_keys(&:to_s).freeze

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :body, presence: true
  validate :technology_tags_are_valid

  scope :published, -> { where(status: :published) }
  scope :recent_first, -> { order(published_at: :desc) }

  def technology_pills
    Array(technology_tags).filter_map do |tag|
      TECHNOLOGY_PILLS[tag.to_s]
    end
  end

  def to_param
    slug
  end

  def to_param
    slug
  end

  def rendered_body
    markdown_renderer.render(body).html_safe
  end

  private

  def set_published_at
    self.published_at = Time.current if published_at.blank?
  end

  def technology_tags_are_valid
    return if technology_tags.blank?

    invalid_tags = Array(technology_tags).map(&:to_s) - TECHNOLOGY_PILLS.keys
    return if invalid_tags.empty?

    errors.add(:technology_tags, "includes unsupported tags: #{invalid_tags.join(", ")}")
  end

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
