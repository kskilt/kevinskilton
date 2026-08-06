require "rails_helper"

RSpec.describe "Agent Log", type: :request do
  it "renders the agent log page" do
    get agent_log_path

    expect(response).to be_successful
    expect(response.body).to include("A richer page for agentic UI delivery.")
    expect(response.body).to include("Agent → Influencer → Team → User")
    expect(response.body).to include("LinkedIn influencer")
  end
end
