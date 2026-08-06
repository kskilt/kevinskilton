require "rails_helper"

RSpec.describe "Agent Log page", type: :system do
  it "renders the agent log with the updated UI styling" do
    visit agent_log_path

    expect(page).to have_text("AGENTIC DESIGN WORKFLOW")
    expect(page).to have_css("link[rel='stylesheet']", visible: false)
    expect(page).to have_css("body.site-shell")
    expect(page).to have_css(".hero-panel")
    expect(page).to have_css("span", text: "DESIGN + AI")
    expect(page).to have_css("h2", text: "Agent → Influencer → Team → User")
  end
end
