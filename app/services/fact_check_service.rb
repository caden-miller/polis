# app/services/fact_check_service.rb
require 'net/http'
require 'json'

class FactCheckService
  BASE_URL = "https://factchecktools.googleapis.com/v1alpha1/claims:search"

  def initialize(query)
    @query = query
  end

  def call
    uri = URI(BASE_URL)
    params = { query: @query, key: Rails.application.credentials.google_fact_check[:api_key] }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get(uri)
    parse_response(response)
  end

  private

  def parse_response(response)
    json = JSON.parse(response)
    if json['claims']
      json['claims'].map do |claim|
        {
          text: claim['text'],
          claimant: claim['claimant'],
          review: claim['claimReview']&.map do |review|
            {
              publisher: review['publisher']['name'],
              rating: review['textualRating'],
              url: review['url']
            }
          end
        }
      end
    else
      []
    end
  end
end
