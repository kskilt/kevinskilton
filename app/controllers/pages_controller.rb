class PagesController < ApplicationController
  def home
    @recent_posts = Post.published.recent_first.limit(3)
  end

  def about
  end

  def agent_log
  end
end
