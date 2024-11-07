class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true, inclusion: { in: [-1, 1] }
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type], message: "can vote only once per item" }
end
