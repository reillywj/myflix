require 'spec_helper'

describe Category do
  it { should have_many(:videos)}

  describe "#recent_videos" do
    it "returns an empty array if there are no videos" do
      drama = Category.create(name: "drama")
      expect(drama.recent_videos).to eq([])

    end
    it "returns an array of videos" do
      drama = Category.create(name: "drama")
      blacklist = Video.create(category: drama, title: "The Blacklist", description: "CI for FBI w/ a blacklist.", created_at: 2.years.ago)
      walkingdead = Video.create(category: drama, title: "The Walking Dead", description: "Zombies.", created_at: 6.years.ago)
      gameofthrones = Video.create(category: drama, title: "Game of Thrones", description: "Middle Age drama", created_at: 4.years.ago)
      orange = Video.create(category: drama, title: "Orange is the New Black", description: "Women's prison.", created_at: 3.years.ago)
      mad_men = Video.create(category: drama, title: "Mad Men", description: "Mid-century marketing drama.", created_at: 8.years.ago)
      ncis = Video.create(category: drama, title: "NCIS", description: "Best damn crime show.", created_at: 12.years.ago)
      videos = [blacklist, walkingdead, gameofthrones, orange, mad_men, ncis]

      videos.each do |video|
        drama.recent_videos.should include(video)
      end
    end
    it "returns an ordered array of videos newest first" do
      drama = Category.create(name: "drama")
      blacklist = Video.create(category: drama, title: "The Blacklist", description: "CI for FBI w/ a blacklist.", created_at: 2.years.ago)
      walkingdead = Video.create(category: drama, title: "The Walking Dead", description: "Zombies.", created_at: 6.years.ago)
      gameofthrones = Video.create(category: drama, title: "Game of Thrones", description: "Middle Age drama", created_at: 4.years.ago)
      orange = Video.create(category: drama, title: "Orange is the New Black", description: "Women's prison.", created_at: 3.years.ago)
      mad_men = Video.create(category: drama, title: "Mad Men", description: "Mid-century marketing drama.", created_at: 8.years.ago)
      ncis = Video.create(category: drama, title: "NCIS", description: "Best damn crime show.", created_at: 12.years.ago)
      videos = [blacklist, walkingdead, gameofthrones, orange, mad_men, ncis]
      
      sorted_videos = videos.sort{|x,y| y.created_at <=> x.created_at}
      drama.recent_videos.should eq(sorted_videos)
    end
    it "returns all videos if less than 6 videos" do
      drama = Category.create(name: "drama")
      blacklist = Video.create(category: drama, title: "The Blacklist", description: "CI for FBI w/ a blacklist.", created_at: 2.years.ago)
      walkingdead = Video.create(category: drama, title: "The Walking Dead", description: "Zombies.", created_at: 6.years.ago)

      expect(drama.recent_videos.count).to eq(2)
    end
    it "returns an array of the 6 most recent videos" do
      drama = Category.create(name: "drama")
      blacklist = Video.create(category: drama, title: "The Blacklist", description: "CI for FBI w/ a blacklist.", created_at: 2.years.ago)
      walkingdead = Video.create(category: drama, title: "The Walking Dead", description: "Zombies.", created_at: 6.years.ago)
      gameofthrones = Video.create(category: drama, title: "Game of Thrones", description: "Middle Age drama", created_at: 4.years.ago)
      orange = Video.create(category: drama, title: "Orange is the New Black", description: "Women's prison.", created_at: 3.years.ago)
      mad_men = Video.create(category: drama, title: "Mad Men", description: "Mid-century marketing drama.", created_at: 8.years.ago)
      ncis = Video.create(category: drama, title: "NCIS", description: "Best damn crime show.", created_at: 12.years.ago)
      americans = Video.create(category: drama, title: "The Americans", description: "Not sure.", created_at: 5.days.ago)
      videos = [blacklist, walkingdead, gameofthrones, orange, mad_men, ncis, americans]
      
      recent_videos = drama.recent_videos
      recent_videos.should eq([americans, blacklist, orange, gameofthrones, walkingdead, mad_men])
      expect(recent_videos.count).to eq(6)
    end
  end
end