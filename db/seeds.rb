# db/seeds.rb

require 'faker'

# Clear existing data to prevent duplication
ActiveRecord::Base.transaction do
  Vote.destroy_all
  Comment.destroy_all
  Post.destroy_all
  Group.destroy_all
  User.destroy_all
end

# Define policy issues
policy_issues = [
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

# Define political affiliations
political_affiliations = ['Republican', 'Moderate', 'Democrat']

# Create a default user account
default_user = User.create!(
  name: 'Caden Miller',
  username: 'cad3n',
  email: 'cadenmiller40@gmail.com',
  password: '123456',
  political_affiliation: 'Moderate',
  role: 'moderator'
)

# Create users with realistic names, emails, and usernames
users = [default_user]
9.times do |i|
  name = Faker::Name.name
  email = Faker::Internet.unique.email
  political_affiliation = political_affiliations.sample

  # For half the users, use their name as the username (lowercase, no spaces)
  if i.even?
    username = name.downcase.gsub(/\s+/, "")
  else
    username = Faker::Internet.unique.username(specifier: name, separators: %w(_))
  end

  users << User.create!(
    name: name,
    username: username,
    email: email,
    password: "password",
    political_affiliation: political_affiliation
  )
end

# Create groups with meaningful descriptions
groups = []
['Environmental Advocates', 'Human Rights Watch', 'Economic Analysts'].each do |group_name|
  groups << Group.create!(
    name: group_name,
    description: "#{group_name} dedicated to discussing and promoting related issues."
  )
end

# Assign users to groups
groups.each do |group|
  group.users << users.sample(5) # Assign 5 random users to each group
end

# Helper method to generate relevant content
def generate_content(policy_issue, title)
  case policy_issue
  when 'Climate Crisis'
    if title.include?('Agriculture')
      "Climate change significantly impacts agricultural productivity. Rising temperatures and unpredictable weather patterns disrupt planting and harvesting cycles, leading to decreased yields. Innovative farming techniques and climate-resilient crops are essential to adapt to these changes."
    elsif title.include?('Oceans')
      "The oceans play a crucial role in regulating the Earth's climate by absorbing carbon dioxide and heat. However, increasing greenhouse gas emissions lead to ocean acidification and rising sea levels, threatening marine ecosystems and coastal communities."
    else
      "Urban areas contribute significantly to greenhouse gas emissions. Sustainable urban planning, including green spaces, efficient public transportation, and renewable energy integration, is vital to reduce the environmental footprint of cities."
    end
  when 'Global Health'
    if title.include?('Inequalities')
      "Global health inequalities stem from disparities in access to healthcare, education, and resources. Addressing these gaps requires international cooperation, investment in healthcare infrastructure, and policies that prioritize vulnerable populations."
    elsif title.include?('Vaccine')
      "Efficient vaccine distribution is critical in combating pandemics. Challenges include cold chain logistics, equitable access, and overcoming vaccine hesitancy. Collaborative efforts can enhance distribution networks and ensure vaccines reach all regions."
    else
      "Mental health is an often-overlooked aspect of global health. Stigmatization and lack of resources prevent many from seeking help. Promoting awareness and integrating mental health services into primary care can improve outcomes worldwide."
    end
  when 'Cyber Issues'
    if title.include?('Cyber Warfare')
      "Cyber warfare poses a significant threat to national security. State and non-state actors can disrupt critical infrastructure, steal sensitive data, and undermine trust in institutions. Strengthening cybersecurity measures is essential to defend against these attacks."
    elsif title.include?('Infrastructure')
      "Protecting critical infrastructure from cyber attacks involves securing networks, implementing robust authentication protocols, and continuous monitoring. Public-private partnerships can enhance the resilience of essential services."
    else
      "The digital age raises concerns about privacy and data protection. With the proliferation of personal data online, there is a need for stringent regulations and technologies that safeguard individual privacy rights."
    end
  else
    # Default content for other policy issues
    "The issue of #{policy_issue.downcase} presents complex challenges that require comprehensive strategies. Stakeholders must collaborate to develop policies that address underlying causes and promote sustainable solutions."
  end
end

# Create posts with thoughtful content related to policy issues
posts = []
policy_issues.each do |policy_issue|
  3.times do
    user = users.sample

    # Generate a meaningful title based on the policy issue
    title = case policy_issue
            when 'Climate Crisis'
              ["Adapting Agriculture to Climate Change", "The Role of Oceans in Climate Regulation", "Urban Planning for a Sustainable Future"].sample
            when 'Global Health'
              ["Addressing Global Health Inequalities", "Innovations in Vaccine Distribution", "Mental Health as a Global Priority"].sample
            when 'Cyber Issues'
              ["The Rising Threat of Cyber Warfare", "Protecting Infrastructure from Cyber Attacks", "Privacy Concerns in the Digital Age"].sample
            # Add more cases for other policy issues as needed
            else
              "#{policy_issue}: Current Challenges and Solutions"
            end

    # Generate content relevant to the title and policy issue
    content = generate_content(policy_issue, title)

    # Occasionally add references
    references = nil
    if rand(1..10) > 6
      hostnames = ['wikipedia.org', 'nytimes.com', 'theguardian.com', 'un.org']
      references = Faker::Internet.url(host: hostnames.sample)
    end

    post = Post.create!(
      title: title,
      content: content,
      references: references,
      policy_issue: policy_issue,
      user: user
    )

    posts << post
  end
end

# Create comments that reflect genuine engagement
posts.each do |post|
  rand(2..5).times do
    Comment.create!(
      content: Faker::Lorem.sentence(word_count: 15),
      user: users.sample,
      post: post
    )
  end
end

# Create votes for posts (upvotes and downvotes)
posts.each do |post|
  users.sample(rand(3..10)).each do |user|
    Vote.create!(
      user: user,
      votable: post,
      value: [1, -1].sample
    )
  end
end

# Output the counts
puts "Created #{User.count} users"
puts "Created #{Group.count} groups"
puts "Created #{Post.count} posts"
puts "Created #{Comment.count} comments"
puts "Created #{Vote.count} votes"
