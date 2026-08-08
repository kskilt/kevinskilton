class PagesController < ApplicationController
  def home
    @recent_posts = Post.published.recent_first.limit(3)
  end

  def about
    @debugging_post = Post.published.find_by(slug: "wrong-screen-ai-overconfidence")
  end

  def agent_log
  end
end
