# app/controllers/facts_controller.rb
class FactsController < ApplicationController
    def index
      if params[:query].present?
        @results = FactCheckService.new(params[:query]).call
      else
        @results = []
      end
    end
  end
  