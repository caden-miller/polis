class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_and_belongs_to_many :groups
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  # Make political affiliation either "Democrat", "Republican", or "Moderate"
  POLITICAL_AFFILIATIONS = %w[Democrat Moderate Republican].freeze
  validates :political_affiliation, inclusion: { in: POLITICAL_AFFILIATIONS }

  def display_name
    name.present? ? name : email
  end
end
