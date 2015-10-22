# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

names = %w(Crooked\ River Middle\ Fork\ Snoqualmie Pass\ Lake Yakima\ River)

lat = [44.128662, 47.523554, 48.416972, 46.802443]

lon = [-120.809838, -121.599248, -122.643913, -120.460374]

water = %w(river small\ stream lake river)

technique = %w(nymph dry\ fly chironomid dry\ fly)

notes = %w(Tons\ of\ big\ fish! Great\ place\ to\ learn! Nice\ lake\ with\ easy\ access\ and\ plenty\ of\ fish Great\ dry\ fly\ fishing!)

User.create!(email: "matt@example.com", password: "password", password_confirmation: "password")

(0..3).each do |index|
  Spot.create!(user: User.find_by(email: "matt@example.com"), name: names[index], lat: lat[index], lon: lon[index], water_type: water[index], technique: technique[index], notes: notes[index])
end
