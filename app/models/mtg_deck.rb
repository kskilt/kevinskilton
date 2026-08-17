class MtgDeck < ApplicationRecord
  validates :archetype_name, presence: true, uniqueness: true
  validates :win_rate, presence: true
  validates :popularity, presence: true
  validates :scraped_at, presence: true

  scope :ranked, -> { order(win_rate: :desc) }
end
