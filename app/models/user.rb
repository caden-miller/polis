class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_and_belongs_to_many :groups
  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  def display_name
    name.present? ? name : email
  end
end
