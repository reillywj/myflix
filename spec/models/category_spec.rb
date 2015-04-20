require 'spec_helper'

describe Category do
  it { should have_many(:videos)}

  describe "#recent_videos" do
    let(:drama) {Fabricate :category, name: "drama"}

    context "with no videos" do
      it "returns an empty array" do
        expect(drama.recent_videos).to eq([])
      end
    end

    context "with videos (6)" do
      let(:blacklist)     {Video.create(category: drama, title: "The Blacklist", description: "CI for FBI w/ a blacklist.", created_at: 2.years.ago)}
      let(:walkingdead)   {Video.create(category: drama, title: "The Walking Dead", description: "Zombies.", created_at: 6.years.ago)}
      let(:gameofthrones) {Video.create(category: drama, title: "Game of Thrones", description: "Middle Age drama", created_at: 4.years.ago)}
      let(:orange)        {Video.create(category: drama, title: "Orange is the New Black", description: "Women's prison.", created_at: 3.years.ago)}
      let(:mad_men)       {Video.create(category: drama, title: "Mad Men", description: "Mid-century marketing drama.", created_at: 8.years.ago)}
      let(:ncis)          {Video.create(category: drama, title: "NCIS", description: "Best damn crime show.", created_at: 12.years.ago)}
      let(:videos)        {[blacklist, walkingdead, gameofthrones, orange, mad_men, ncis]}

      it "returns an array of videos" do
        videos.each do |video|
          drama.recent_videos.should include(video)
        end
      end

      it "returns an ordered array of videos newest first" do
        sorted_videos = videos.sort{|x,y| y.created_at <=> x.created_at}
        expect(drama.recent_videos).to eq(sorted_videos)
      end

      it "returns an array of the 6 most recent videos when more than 6" do
        videos
        americans = Video.create(category: drama, title: "The Americans", description: "Not sure.", created_at: 5.days.ago)
        expect(drama.recent_videos).to eq([americans, blacklist, orange, gameofthrones, walkingdead, mad_men])
        expect(drama.recent_videos.count).to eq(6)
      end
    end

    context "with less than 6 videos (2 videos)" do
      it "returns all videos if less than 6 videos" do
        2.times {Fabricate(:video, category: drama)}

        expect(drama.recent_videos.count).to eq(2)
      end
    end

  end
end