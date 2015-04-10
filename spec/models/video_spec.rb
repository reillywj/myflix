require 'spec_helper'

describe Video do
  it { should belong_to(:category)}
  it { should have_many(:reviews)}
  it { should validate_presence_of(:title)}
  it { should validate_presence_of(:description)}

  describe "search_by_title" do
    it "returns an empty array if there is no match" do
      tv = Category.create(name: "tv")
      futurama = Video.create(title: "Futurama", description: "Space Travel!", category: tv)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel", category: tv)
      expect(Video.search_by_title("hello")).to eq([])
    end
    it "returns an array of one video for an exact match" do
      tv = Category.create(name: "tv")
      futurama = Video.create(title: "Futurama", description: "Space Travel!", category: tv)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel", category: tv)
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end
    it "returns an array of one video for a partial match" do
      tv = Category.create(name: "tv")
      futurama = Video.create(title: "Futurama", description: "Space Travel!", category: tv)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel", category: tv)
      expect(Video.search_by_title("urama")).to eq([futurama])
    end
    it "returns an array of all matches ordered by created_at" do
      tv = Category.create(name: "tv")
      futurama = Video.create(title: "Futurama", description: "Space Travel!", category: tv, created_at: 1.day.ago)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel", category: tv)
      expect(Video.search_by_title("Futur")).to eq([back_to_future, futurama])
    end
    it "returns an empty array if search term is blank" do
      tv = Category.create(name: "tv")
      futurama = Video.create(title: "Futurama", description: "Space Travel!", category: tv)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel", category: tv)
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe "ordered_reviews" do
    before { Fabricate(:video)}
    it "should return an empty array if there are no reviews" do
      video = Video.first
      expect(video.ordered_reviews).to eq([])
    end
    it "should return an array of one review if there is only one review" do
      video = Video.first
      review = Fabricate(:review, video: video)
      expect(video.ordered_reviews).to eq([review])
    end
    it "should return reviews in reverse chronological order" do
      video = Video.first
      r1 = Fabricate(:review, video: video, created_at: 3.days.ago)
      r2 = Fabricate(:review, video: video, created_at: 1.days.ago)
      r3 = Fabricate(:review, video: video, created_at: 1.years.ago)
      expect(video.ordered_reviews).to eq([r2, r1, r3])
    end
  end
  describe "count_reviews" do
    it "should return 0 if there are no reviews" do
      video = Fabricate(:video)
      expect(video.count_reviews).to eq(0)
    end
    it "should return 1 if there is only one review" do
      video = Fabricate(:video)
      Fabricate(:review, video: video)
      expect(video.count_reviews).to eq(1)
    end
    it "should return 5 if there are 5 reviews" do
      video = Fabricate(:video)
      5.times { Fabricate(:review, video: video)}
      expect(video.count_reviews).to eq(5)
    end
  end
  describe "sum_review_ratings" do
    it "should return 0 if there are no reviews" do
      video = Fabricate(:video)
      expect(video.sum_review_ratings).to eq(0)
    end
    it "should return 4 if there is one review with a rating of 4" do
      video = Fabricate(:video)
      Fabricate(:review, video: video, rating: 4)
      expect(video.sum_review_ratings).to eq(4)
    end
    it "should return 5 if there are two reviews with a rating of 2 and 3" do
      video = Fabricate(:video)
      [2, 3].each do |i|
        Fabricate(:review, video: video, rating: i)
      end
      expect(video.sum_review_ratings).to eq(5)
    end
    it "should return 15 if there are 5 reviews with ratings of 1,2,3,4, and 5" do
      video = Fabricate(:video)
      (1..5).each do |i|
        Fabricate(:review, video: video, rating: i)
      end
      expect(video.sum_review_ratings).to eq(15)
    end
  end
  describe "average_rating_of_reviews" do 
    it "returns nil if there are no reviews" do
      video = Fabricate(:video)
      expect(video.average_rating_of_reviews).to be_nil
    end
    it "returns 1.0 if there is only one review with a rating of 1" do
      video = Fabricate(:video)
      Fabricate(:review, video: video, rating: 1)
      expect(video.average_rating_of_reviews).to eq(1.0)
    end
    it "returns 5.0 if there is only one review with a rating of 5" do
      video = Fabricate(:video)
      Fabricate(:review, video: video, rating: 5)
      expect(video.average_rating_of_reviews).to eq(5.0)
    end
    it "returns 5.0 if there are 10 reviews with a rating of 5 each" do
      video = Fabricate(:video)
      10.times {Fabricate(:review, video: video, rating: 5)}
      expect(video.average_rating_of_reviews).to eq(5.0)
    end
    it "returns 1.0 if there are 20 reviews with a rating of 1 each" do
      video = Fabricate(:video)
      10.times {Fabricate(:review, video: video, rating: 1)}
      expect(video.average_rating_of_reviews).to eq(1.0)
    end
    it "returns 3.5 if there are 2 reviews with a rating of 3 and 4 respectively" do
      video = Fabricate(:video)
      [3,4].each do |i|
        Fabricate(:review, video: video, rating: i)
      end
      expect(video.average_rating_of_reviews).to eq(3.5)
    end
    it "returns 3.25 if there are 4 reviews with a rating of 3, 3, 3, and 4 respectively" do
      video = Fabricate(:video)
      [3,3,3,4].each do |i|
        Fabricate(:review, video: video, rating: i)
      end
      expect(video.average_rating_of_reviews).to eq(3.25)
    end
    it "returns 3.33 if there are 3 reviews with a rating of 3, 3, and 4 respectively" do
      video = Fabricate(:video)
      [3,3,4].each do |i|
        Fabricate(:review, video: video, rating: i)
      end
      expect(video.average_rating_of_reviews).to eq(3.33)
    end
    it "returns 3.67 if there are 3 reviews with a rating of 3, 4, and 4 respectively" do
      video = Fabricate(:video)
      [3,4,4].each do |i|
        Fabricate(:review, video: video, rating: i)
      end
      expect(video.average_rating_of_reviews).to eq(3.67)
    end
  end
  
end