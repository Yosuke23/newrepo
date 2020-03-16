User.create!(name: "Example User",
	         email: "example@railstutorial.org",
	         password:           "foobar",
	         password_confirmation:  "foobar",
	         admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
 name = Faker::Name.name
 email = "example-#{n + 1}@railstutorial.org"
 password = "password"
 User.create!(name: name,
  	           email: email,
  	           password: password,
  	           password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
content = Faker::Lorem.sentence(5)
users.each { |user| user.microposts.create!(content: content) }
end
# リレーションシップ
users = User.all
user = User.first
following = users[2..50] # フォローして居るユーザーを定義
followers = users[3..40] # フォロワーを定義
following.each { |followed| user.follow(followed) }
#最初のユーザーにユーザー3からユーザー51までのユーザーをフォローさせる
followers.each { |follower| follower.follow(user) }
#→4から41のユーザーに最初のユーザーをフォローさせる

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)