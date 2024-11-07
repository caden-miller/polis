# app/controllers/comments_controller.rb

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create]
  before_action :set_comment, only: [:upvote, :downvote, :report]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: 'Comment was successfully posted.'
    else
      @comments = @post.comments.includes(:user)
      render 'posts/show', status: :unprocessable_entity
    end
  end
  
  def upvote
    @comment.votes.create(user: current_user, value: 1)

    respond_to do |format|
      format.html { redirect_to @comment.post }
      format.js
    end
  end

  def downvote
    @comment.votes.create(user: current_user, value: -1)

    respond_to do |format|
      format.html { redirect_to @comment.post }
      format.js
    end
  end

  def report
    @comment.update(reported: true)
    redirect_to @comment.post, notice: "Comment has been reported."
  end

  private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
end
