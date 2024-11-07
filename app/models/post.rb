class Post < ApplicationRecord
  belongs_to :user, optional: true
  has_many_attached :images
  has_many :comments, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  # Validations (optional but recommended)
  validates :title, presence: true
  validates :content, presence: true

  def vote_count
    votes.sum(:value)
  end

  POLICY_ISSUES = [
    'Anti-Corruption and Transparency',
    'Arms Control and Nonproliferation',
    'Climate Crisis',
    'Combating Drugs and Crime',
    'Covid-19 Recovery',
    'Countering Terrorism',
    'Cyber Issues',
    'Economic Prosperity and Trade Policy',
    'Energy',
    'Global Health',
    'Global Women’s Issues',
    'Human Rights and Democracy',
    'Human Trafficking',
    'The Ocean and Polar Affairs',
    'Refugee and Humanitarian Assistance',
    'Science, Technology, and Innovation',
    'Treaties and International Agreements'
  ]

  validates :policy_issue, inclusion: { in: POLICY_ISSUES }
end
