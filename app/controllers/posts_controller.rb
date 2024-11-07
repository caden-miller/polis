class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comments = @post.comments.includes(:user)
  end

  # GET /posts/new
  def new
    @post = current_user.posts.build
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
    if @post.update(post_params.except(:images))
      # Attach new images only if images are present in the params
      if params[:post][:images].present?
        @post.images.attach(params[:post][:images]) # Attach new images, without purging the existing ones
      end
  
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
    @post.update(reported: true)
    redirect_to @post, notice: "Post has been reported."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :references, :policy_issue, images: [])
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to posts_path, notice: "Not authorized to edit this post" if @post.nil?
    end
end
