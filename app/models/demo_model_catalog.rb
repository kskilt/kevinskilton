# Small, illustrative stand-in for a real "which AI models are safe to offer
# users, and how does each one change the request we send" catalog. Not
# production code — built to demonstrate the shape of a real solution on the
# /demo case-study page without reproducing any employer's actual source.
class DemoModelCatalog
  Model = Struct.new(:id, :label, :supports_temperature, :forces_reasoning_none)

  # Deliberately append-only, like the real thing this is modeled on: if this
  # list ever backs a Rails `enum`, reordering existing entries would silently
  # remap every already-saved value to a different model.
  MODELS = [
    Model.new("gpt-4.1", "GPT-4.1", true, false),
    Model.new("gpt-5", "GPT-5", false, false),
    Model.new("gpt-5-mini", "GPT-5 Mini", false, false),
    Model.new("gpt-5.4", "GPT-5.4", false, true)
  ].freeze

  def self.find(id)
    MODELS.find { |model| model.id == id } || MODELS.first
  end

  def self.options_for_select
    MODELS.map { |model| [ model.label, model.id ] }
  end
end
