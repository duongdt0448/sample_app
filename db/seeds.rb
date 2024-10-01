User.create!(name: "Example User",
              email: "example@railstutorial.org",
              password: "foobar",
              password_confirmation: "foobar",
              admin: true,
              activated: true,
              activated_at: Time.zone.now)

elasticsearch_service = ElasticSearchService.new

index_name = 'microposts'
elasticsearch_service.create_index(index_name, '{
  "content": { "type": "text" }
}')

10.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
                email: email,
                password: password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)

10.times do |n|
  users.each do |user|
    content = Faker::Lorem.sentence(word_count: 5)
    micropost = user.microposts.create!(content: content)

    elasticsearch_service.create_document index_name, micropost, micropost.id
  end
end

users = User.all
user = users.first
following = users[2..20]
followers = users[3..15]
following.each{|followed| user.follow(followed)}
followers.each{|follower| follower.follow(user)}
