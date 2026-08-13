class PagesController < ApplicationController
  AGENT_FILES = [
    { label: "rails-locator", path: ".claude/agents/rails-locator.md" },
    { label: "scoped-implementer", path: ".claude/agents/scoped-implementer.md" },
    { label: "diff-validator", path: ".claude/agents/diff-validator.md" }
  ].freeze

  DEMO_TABS = %w[story working_demo code].freeze
  DEFAULT_DEMO_PROMPT = "Answer questions about our product."
  DEMO_PROMPT_MAX_LENGTH = 160

  def home
    @recent_posts = Post.published.recent_first.limit(3)
  end

  def about
    @debugging_post = Post.published.find_by(slug: "wrong-screen-ai-overconfidence")
  end

  def agent_log
    @agent_files = AGENT_FILES.map do |file|
      { name: file[:path], label: file[:label], content: File.read(Rails.root.join(file[:path])) }
    end
  end

  def demo
    @tab = DEMO_TABS.include?(params[:tab]) ? params[:tab] : "story"
    @selected_model = DemoModelCatalog.find(params[:model])
    @prompt = params[:prompt].presence&.slice(0, DEMO_PROMPT_MAX_LENGTH) || DEFAULT_DEMO_PROMPT
    @request_preview = DemoRequestPreview.new(model: @selected_model, prompt: @prompt)
    @code_diffs = DemoCodeDiffs.all

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update("demo-panel", partial: "pages/demo_panel") }
    end
  end
end
