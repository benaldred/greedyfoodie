class PostsController < ApplicationController
  def index
    @posts = Post.by_latest_published(:limit => 5)
  end

  def show
  end

end
