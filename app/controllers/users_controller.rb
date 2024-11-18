# app/controllers/users_controller.rb

class UsersController < ApplicationController
  before_action :set_user, only: %i[ show ]

  def show
    if @user.nil?
      redirect_to root_path, alert: "User not found."
      return
    end

    @user = User.find(params[:id])
    @total_karma = @user.votes.sum(:value)
    @total_votes = @user.votes.count
    @average_vote_value = @total_votes > 0 ? (@user.votes.average(:value).to_f.round(2)) : 0
    @posts = @user.posts
    @comments = @user.comments
    @groups = @user.groups
    @votes = @user.votes
  end

  private

  def set_user
    return if params[:id] == 'sign_out'

    @user = User.find(params[:id])
  end
end
