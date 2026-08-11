class PostsController < ApplicationController
  def index
    @posts = Post.published.recent_first

    respond_to do |format|
      format.html
      format.rss
    end
  end

  def show
    @post = Post.published.find_by!(slug: params[:slug])
  end
end
