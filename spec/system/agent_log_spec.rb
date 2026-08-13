require "rails_helper"

RSpec.describe "Agent Log page", type: :system do
  it "renders the real agent definitions as clickable React tabs" do
    visit agent_log_path

    expect(page).to have_css("body.site-shell")
    expect(page).to have_css(".hero-panel")
    expect(page).to have_text("Not a summary")

    expect(page).to have_button("rails-locator")
    expect(page).to have_button("scoped-implementer")
    expect(page).to have_button("diff-validator")

    expect(page).to have_text("You investigate a single, narrowly-stated question")

    click_on "scoped-implementer"

    expect(page).to have_text("You implement one task in the")
    expect(page).not_to have_text("You investigate a single, narrowly-stated question")
  end
end
