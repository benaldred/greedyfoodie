class PostsController < ApplicationController
  def index
    @posts = Post.by_created_at(:limit => 5)
  end

  def show
  end

end
