require "rails_helper"

RSpec.describe "Demo case study", type: :request do
  it "defaults to the story tab" do
    get demo_path

    expect(response).to be_successful
    expect(response.body).to include("Letting people choose their own AI model")
    expect(response.body).to include('class="badge demo-tab-active"')
  end

  it "renders the working demo tab with the default model's request preview" do
    get demo_path(tab: "working_demo")

    expect(response).to be_successful
    expect(response.body).to include("gpt-4.1")
    expect(response.body).to include('temperature: 0.7')
    expect(response.body).to include("file_8f2a1c9d")
    expect(response.body).to include("Answer questions about our product.")
    expect(response.body).to include("class=\"model-highlight\"")
  end

  it "reflects a custom prompt in the console output and caps its length" do
    get demo_path(tab: "working_demo", prompt: ("x" * 500))

    expect(response).to be_successful
    expect(response.body.scan("x" * 500)).to be_empty
    expect(response.body).to include("x" * PagesController::DEMO_PROMPT_MAX_LENGTH)
  end

  it "renders the code tab" do
    get demo_path(tab: "code")

    expect(response).to be_successful
    expect(response.body).to include("KNOWN_MODELS")
    expect(response.body).to include("from-scratch reconstruction")
  end

  it "ignores an unknown tab and falls back to the story tab" do
    get demo_path(tab: "not-a-real-tab")

    expect(response).to be_successful
    expect(response.body).to include("Letting people choose their own AI model")
  end

  it "updates the request preview via turbo_stream when a different model is selected" do
    get demo_path(tab: "working_demo", model: "gpt-5.4"), headers: { "Accept" => "text/vnd.turbo-stream.html" }

    expect(response).to be_successful
    expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    expect(response.body).to include("temperature omitted")
    expect(response.body).to include("reasoning_effort: &quot;none&quot;")
  end
end
