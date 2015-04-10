Fabricator(:review) do
  rating { Faker::Number.between(1,5).to_i}
  review { Faker::Lorem.paragraph(Faker::Number.between(1,4))}
  user { Fabricate(:user)}
  video { Fabricate(:video)}
end