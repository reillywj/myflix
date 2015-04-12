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
comedy = Category.create(name: "Comedy")

covers = ["tmp/family_guy.jpg", "tmp/futurama.jpg", "tmp/monk.jpg", "tmp/south_park.jpg"]

major_payne = Video.create(category: comedy, title: "Major Payne", description: "Young soldiers grow up.", small_cover_url: covers.sample, large_cover_url: "tmp/monk_large.jpg")

mike = User.create(full_name: "Mike Ditka", email: "mike@example.com", password: "mike")
john = User.create(full_name: "John S. Smith", email: "john@example.com", password: "john")

Review.create(rating: 5, review: "Best comedy of the 90s.", video: major_payne, user: mike)
Review.create(rating: 4, review: "Great comedy classic!", video: major_payne, user: john)

video_titles.each do |title|
  disney_video = Video.create(category: disney, title: title, description: "Disney story of #{title}.", small_cover_url: covers.sample, large_cover_url: "tmp/monk_large.jpg")
end