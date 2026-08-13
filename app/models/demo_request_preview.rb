# Builds the fake "what the actual API request looks like" lines shown as
# rails-console-style output on the /demo page's Working Demo tab. Illustrative
# data only — not a real request, not real user content.
class DemoRequestPreview
  FAKE_USER_INPUT = "What's included in the enterprise plan?"
  FAKE_FILE_ID = "file_8f2a1c9d"

  def initialize(model:, prompt:)
    @model = model
    @prompt = prompt.to_s.gsub(/\s+/, " ").strip
  end

  def lines
    [
      "model: \"#{@model.id}\",",
      "instructions: \"#{@prompt}\",",
      "input: \"#{FAKE_USER_INPUT}\",",
      "file_ids: [\"#{FAKE_FILE_ID}\"],",
      temperature_line,
      reasoning_effort_line
    ].compact
  end

  private

  def temperature_line
    @model.supports_temperature ? "temperature: 0.7" : "# temperature omitted — GPT-5+ doesn't accept it"
  end

  def reasoning_effort_line
    "reasoning_effort: \"none\"" if @model.forces_reasoning_none
  end
end
