class Reference < ApplicationRecord
  belongs_to :post

  validates :text, presence: true
  validates :url, presence: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
end
