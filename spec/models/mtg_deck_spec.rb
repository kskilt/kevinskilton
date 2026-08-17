require "rails_helper"

RSpec.describe MtgDeck, type: :model do
  context "validation", :aggregate_failures do
    subject { build(:mtg_deck) }

    it { is_expected.to validate_presence_of(:archetype_name) }
    it { is_expected.to validate_uniqueness_of(:archetype_name) }
    it { is_expected.to validate_presence_of(:win_rate) }
    it { is_expected.to validate_presence_of(:popularity) }
    it { is_expected.to validate_presence_of(:scraped_at) }
  end

  describe ".ranked" do
    let!(:low_win_rate_deck) { create(:mtg_deck, archetype_name: "Mono Red", win_rate: 45.0) }
    let!(:high_win_rate_deck) { create(:mtg_deck, archetype_name: "Azorius Control", win_rate: 58.2) }

    it "orders decks by win rate descending" do
      expect(described_class.ranked).to eq([ high_win_rate_deck, low_win_rate_deck ])
    end
  end
end
