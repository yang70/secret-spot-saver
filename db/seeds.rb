# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

names = %w(Secret Spot, Favorite Spot, Trout Lake, Yakima River)

water = %w(river, small stream, lake, river)

technique = %w(nymph, dry w/ dropper, chironomid, dry)

notes = %(Tons of big fish!, This is my favorite spot in the world!, Nice lake with easy access and plenty of fish, Great dry fly fishing!)

User.create!(email: "matt@example.com", password: "password", password_confirmation: "password")

(0..3).each do |index|
  Spot.create!(user: User.find_by(email: "matt@example.com"), name: names[index], lat: 45, lon: -73, water_type: water[index], technique: technique[index], notes: notes[index])
end
