# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
video_titles = ["Might Joe Young", "Flubber", "The Little Mermaid", "Bambi", "Beauty and the Beast", "Cars", "Remember the Titans"]
videos = []
disney = Category.create(name: "Disney")
video_titles.each do |title|
  Video.create(category: disney, title: title, description: "Disney story of #{title}.", small_cover_url: "tmp/monk.jpg", large_cover_url: "tmp/monk_large.jpg")
end