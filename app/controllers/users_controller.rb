# app/controllers/users_controller.rb

class UsersController < ApplicationController
  before_action :set_user

  def show
    @posts = @user.posts.order(created_at: :desc)
    @comments = @user.comments.order(created_at: :desc)
    @votes = @user.votes.includes(:votable).order(created_at: :desc)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
