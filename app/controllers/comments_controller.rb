# app/controllers/comments_controller.rb

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:create, :destroy]
  before_action :set_comment, only: [:upvote, :downvote, :report, :destroy]
  before_action :correct_user, only: [:destroy]

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

  def destroy
    @comment.destroy
    redirect_to @post, notice: 'Comment was successfully deleted.'
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
    @comment.increment!(:reports_count)
    redirect_to @comment.post, notice: "Comment has been reported."
  end

  def content_with_references
    # Assuming comments can have references (you'd need to set up associations accordingly)
    processed_content = content.dup
    references.each do |reference|
      placeholder = "[#{reference.text}]"
      link = ActionController::Base.helpers.link_to(reference.text, reference.url, target: "_blank", rel: "noopener noreferrer", class: "text-blue-600 hover:underline")
      processed_content.gsub!(placeholder, link)
    end
    processed_content.html_safe
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def correct_user
      unless current_user == @comment.user
        redirect_to @post, alert: "Not authorized to delete this comment."
      end
    end
end
