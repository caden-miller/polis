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
  validates :name, :email, :password, presence: true
  validates :username, presence: true, uniqueness: true
  validates :political_affiliation, inclusion: { in: POLITICAL_AFFILIATIONS }, presence: true

  ROLES = %w[user moderator]

  # Validations
  validates :role, inclusion: { in: ROLES }

  def display_name
    username
  end
end
