class Post < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :references, dependent: :destroy
  accepts_nested_attributes_for :references, allow_destroy: true, reject_if: :all_blank

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

  validates :title, presence: true
  validates :content, presence: true
  validates :policy_issue, inclusion: { in: POLICY_ISSUES }

  def vote_count
    votes.sum(:value)
  end

  def content_with_references
    processed_content = content.dup
    references.each do |reference|
      placeholder = "[#{reference.text}]"
      link = ActionController::Base.helpers.link_to(reference.text, reference.url, target: "_blank", rel: "noopener noreferrer", class: "text-blue-600 hover:underline")
      processed_content.gsub!(placeholder, link)
    end
    processed_content.html_safe
  end
end
