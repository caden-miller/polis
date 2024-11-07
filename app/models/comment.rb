class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :votes, as: :votable, dependent: :destroy

  def vote_count
    votes.sum(:value)
  end

  validates :content, presence: true
end

