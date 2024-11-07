class VotesController < ApplicationController
    before_action :authenticate_user!
  
    def upvote
      @post = Post.find(params[:id])
      vote = @post.votes.find_or_initialize_by(user: current_user)
      vote.value = 1
      if vote.save
        respond_to do |format|
          format.html { redirect_to posts_path, notice: 'Upvoted!' }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("post_votes_#{@post.id}", partial: "posts/vote_count", locals: { post: @post }) }
        end
      else
        # Handle errors
      end
    end
  
    def downvote
      @post = Post.find(params[:id])
      vote = @post.votes.find_or_initialize_by(user: current_user)
      vote.value = -1
      if vote.save
        respond_to do |format|
          format.html { redirect_to posts_path, notice: 'Downvoted!' }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("post_votes_#{@post.id}", partial: "posts/vote_count", locals: { post: @post }) }
        end
      else
        # Handle errors
      end
    end
  end
  