require "rails_helper"

RSpec.describe "Internal::MtgRankings", type: :request do
  let(:token) { "test-ingest-token" }
  let(:valid_headers) do
    { "Authorization" => "Bearer #{token}", "CONTENT_TYPE" => "application/json" }
  end

  around do |example|
    original_token = ENV["MTG_INGEST_TOKEN"]
    ENV["MTG_INGEST_TOKEN"] = token
    example.run
    ENV["MTG_INGEST_TOKEN"] = original_token
  end

  describe "POST /internal/mtg_rankings" do
    let(:payload) do
      {
        decks: [
          { archetype_name: "Azorius Control", win_rate: 58.2, popularity: 12.4 },
          { archetype_name: "Mono Red Aggro", win_rate: 51.7, popularity: 9.3 }
        ]
      }
    end

    context "with a valid bearer token" do
      it "creates new archetype rows" do
        expect {
          post "/internal/mtg_rankings", params: payload.to_json, headers: valid_headers
        }.to change(MtgDeck, :count).by(2)

        expect(response).to be_successful
        expect(MtgDeck.find_by(archetype_name: "Azorius Control").win_rate).to eq(58.2)
      end

      it "upserts an existing archetype row in place by archetype_name" do
        existing = create(:mtg_deck, archetype_name: "Azorius Control", win_rate: 40.0, popularity: 5.0)

        expect {
          post "/internal/mtg_rankings", params: payload.to_json, headers: valid_headers
        }.to change(MtgDeck, :count).by(1)

        expect(response).to be_successful
        expect(existing.reload.win_rate).to eq(58.2)
      end
    end

    context "with a missing token" do
      it "returns 401 and makes no database changes" do
        expect {
          post "/internal/mtg_rankings", params: payload.to_json, headers: { "CONTENT_TYPE" => "application/json" }
        }.not_to change(MtgDeck, :count)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with an incorrect token" do
      it "returns 401 and makes no database changes" do
        headers = { "Authorization" => "Bearer wrong-token", "CONTENT_TYPE" => "application/json" }

        expect {
          post "/internal/mtg_rankings", params: payload.to_json, headers: headers
        }.not_to change(MtgDeck, :count)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with a malformed payload" do
      it "rejects a missing decks key without raising" do
        post "/internal/mtg_rankings", params: {}.to_json, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_content)
      end

      it "rejects a deck missing required fields without raising" do
        malformed_payload = { decks: [ { archetype_name: "Azorius Control" } ] }

        post "/internal/mtg_rankings", params: malformed_payload.to_json, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_content)
      end

      it "rejects a non-array decks value without raising" do
        malformed_payload = { decks: "not-an-array" }

        post "/internal/mtg_rankings", params: malformed_payload.to_json, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
