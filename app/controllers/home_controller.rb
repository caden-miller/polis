# app/controllers/home_controller.rb

class HomeController < ApplicationController
    def index
      @policy_issues = Post::POLICY_ISSUES
      @posts_by_policy_issue = {}
  
      @policy_issues.each do |issue|
        @posts_by_policy_issue[issue] = Post.where(policy_issue: issue).order(created_at: :desc).limit(3)
      end
    end
  end
  