FactoryBot.define do
  factory :mtg_deck do
    sequence(:archetype_name) { |n| "Test Archetype #{n}" }
    win_rate { 54.3 }
    popularity { 8.1 }
    scraped_at { Time.current }
  end
end
