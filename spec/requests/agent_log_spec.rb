require "rails_helper"

RSpec.describe "Agent Log", type: :request do
  it "renders the agent log page" do
    get agent_log_path

    expect(response).to be_successful
    expect(response.body).to include("Not a summary")
    expect(response.body).to include("rails-locator")
    expect(response.body).to include("scoped-implementer")
    expect(response.body).to include("diff-validator")
    expect(response.body).to include("You investigate a single, narrowly-stated question")
    expect(response.body).to include('id="agent-log-data"')
  end
end
