require "rails_helper"

RSpec.describe "Pages", type: :request do
  it "renders the landing page" do
    get root_path

    expect(response).to be_successful
    expect(response.body).to include("Shipping ideas, code, and a better dev experience")
    expect(response.body).to include("Explore the blog")
    expect(response.body).to include("hero-panel")
  end

  it "renders the about page" do
    get about_path

    expect(response).to be_successful
    expect(response.body).to include("About Kevin")
    expect(response.body).to include("linkedin.com/in/kskilt")
    expect(response.body).to include("rather verify something works than trust that it sounds like it does")
  end

  describe "GET /hobbies" do
    it "renders ranked archetypes by win rate descending" do
      low_win_rate_deck = create(:mtg_deck, archetype_name: "Mono Red Aggro", win_rate: 45.0)
      high_win_rate_deck = create(:mtg_deck, archetype_name: "Azorius Control", win_rate: 58.2)

      get hobbies_path

      expect(response).to be_successful
      expect(response.body.index(high_win_rate_deck.archetype_name))
        .to be < response.body.index(low_win_rate_deck.archetype_name)
    end

    it "shows a fallback message when no rankings have been scraped yet" do
      get hobbies_path

      expect(response).to be_successful
      expect(response.body).to include("Rankings haven't been scraped yet")
    end
  end
end
