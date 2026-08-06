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
    expect(response.body).to include("I spend my time shaping thoughtful code")
  end
end
