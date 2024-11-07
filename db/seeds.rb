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

# Create users with realistic names and emails
users = []
10.times do
  users << User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password",
    political_affiliation: political_affiliations.sample
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

# Create posts with thoughtful content related to policy issues
posts = []
50.times do
  user = users.sample
  policy_issue = policy_issues.sample
  title = case policy_issue
          when 'Climate Crisis'
            ["The Impact of Climate Change on Coastal Communities", "Renewable Energy Solutions for a Greener Future"].sample
          when 'Global Health'
            ["Strategies to Combat Global Pandemics", "Improving Access to Healthcare Worldwide"].sample
          when 'Cyber Issues'
            ["Cybersecurity in the Modern Age", "Protecting Personal Data Online"].sample
          else
            "Discussion on #{policy_issue}"
          end

  content = Faker::Lorem.paragraph(sentence_count: 5)

  hostnames = ['wikipedia.org', 'nytimes.com', 'cnn.com', 'bbc.com']
  if rand(1..10) > 6
    references = Faker::Internet.url(host: hostnames.sample)
  end

  post = Post.create!(
    title: title,
    content: content,
    references: references,
    policy_issue: policy_issue,
    user: user
  )

  # Optionally attach an image (ensure you have images in db/seeds/images)
  if rand(1..10) > 6
    image_path = Rails.root.join('db', 'seeds', 'images', "image#{rand(1..5)}.jpg")
    post.images.attach(io: File.open(image_path), filename: File.basename(image_path)) if File.exist?(image_path)
  end

  posts << post
end

# Create comments that reflect genuine engagement
posts.each do |post|
  rand(2..5).times do
    Comment.create!(
      content: Faker::Lorem.sentence(word_count: 12),
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
