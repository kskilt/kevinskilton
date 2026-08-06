FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "Test Post #{n}" }
    slug { title.parameterize }
    body { "Some sample content." }
    status { :published }
    published_at { 1.day.ago }
    technology_tags { %w[ruby rails rspec] }
  end
end
