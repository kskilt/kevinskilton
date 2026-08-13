class PagesController < ApplicationController
  AGENT_FILES = [
    { label: "rails-locator", path: ".claude/agents/rails-locator.md" },
    { label: "scoped-implementer", path: ".claude/agents/scoped-implementer.md" },
    { label: "diff-validator", path: ".claude/agents/diff-validator.md" }
  ].freeze

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
end
