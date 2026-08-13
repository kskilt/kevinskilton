require "rails_helper"

RSpec.describe "Demo case study page", type: :system do
  it "switches tabs and updates the live model preview via Turbo Streams" do
    visit demo_path

    expect(page).to have_text("Letting people choose their own AI model")
    expect(page).to have_text("freedom to experiment")

    click_on "Working demo"

    expect(page).to have_text("actual request shape changing")
    expect(page).to have_text('temperature: 0.7')
    expect(page).to have_text("file_8f2a1c9d")

    fill_in "Prompt", with: "Track my order status"
    find_field("Prompt").send_keys(:tab)

    expect(page).to have_text("Track my order status")

    select "GPT-5.4", from: "Model"

    expect(page).to have_text("temperature omitted")
    expect(page).to have_text('reasoning_effort: "none"')

    click_on "The code"

    expect(page).to have_text("KNOWN_MODELS")
    expect(page).to have_text("from-scratch reconstruction")
  end
end
