class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :authenticate_moderator!, only: [:verify]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
    # Filtering by date range
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
      @posts = @posts.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    end

    # Sorting
    case params[:sort]
    when 'most_voted'
      @posts = @posts.most_voted
    when 'highest_average'
      @posts = @posts.highest_average
    when 'trending'
      @posts = @posts.trending
    when 'verified'
      @posts = @posts.verified
    else
      @posts = @posts.order(created_at: :desc) # Default to recency
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comments = @post.comments.includes(:user)
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
    @post.references.build  # Build a new reference
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user  # Assign the current user to the post
  
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      respond_to do |format|
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def upvote
    @post = Post.find(params[:id])
    vote = @post.votes.find_or_initialize_by(user: current_user)
    vote.value = 1
    if vote.save
      respond_to do |format|
        format.html { redirect_to posts_path, notice: 'Upvoted!' }
        format.turbo_stream
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
        format.turbo_stream
      end
    else
      # Handle errors
    end
  end

  def policy_issue
    @policy_issue = params[:policy_issue]
    @posts = Post.where(policy_issue: @policy_issue)
  end

  def report
    @post = Post.find(params[:id])
    @post.increment!(:reports_count)
    redirect_to @post, notice: "Post has been reported."
  end

  def verify
    @post = Post.find(params[:id])
    @post.update(verified: true)
    redirect_to @post, notice: "Post has been verified."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :policy_issue, references_attributes: [:id, :text, :url, :_destroy])
    end
    
    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to posts_path, notice: "Not authorized to edit this post" if @post.nil?
    end

    def authenticate_moderator!
      unless current_user&.role == "moderator"
        redirect_to posts_path, alert: "Not authorized."
      end
    end
end
