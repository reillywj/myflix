Fabricator(:queue_item) do
  position { (1..10).to_a.sample}
  video {Fabricate(:video)}
  user {Fabricate(:user)}
end