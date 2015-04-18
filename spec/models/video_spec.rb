require 'spec_helper'

describe Video do
  it { should belong_to(:category)}
  it { should have_many(:reviews)}
  it_validates_presence_of_set :title, :description

  describe "search_by_title" do
    let(:tv) {Fabricate(:category, name: "tv")}
    let(:futurama) { Video.create title: "Futurama", description: "Space Travel!", category: tv, created_at: 1.day.ago}
    let(:back_to_future) {Video.create title: "Back to Future", description: "Time Travel", category: tv}

    it "returns an empty array if there is no match" do
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      expect(Video.search_by_title("Futurama")).to eq([futurama])
    end

    it "returns an array of one video for a partial match" do
      expect(Video.search_by_title("urama")).to eq([futurama])
    end

    it "returns an array of all matches ordered by created_at" do
      expect(Video.search_by_title("Futur")).to eq([back_to_future, futurama])
    end

    it "returns an empty array if search term is blank" do
      expect(Video.search_by_title("")).to eq([])
    end
  end

  describe "ordered_reviews" do
    let(:video) {Fabricate :video}

    it "should return an empty array if there are no reviews" do
      expect(video.ordered_reviews).to eq([])
    end

    it "should return an array of one review if there is only one review" do
      review = Fabricate(:review, video: video)
      expect(video.ordered_reviews).to eq([review])
    end

    it "should return reviews in reverse chronological order" do
      r1 = Fabricate(:review, video: video, created_at: 3.days.ago)
      r2 = Fabricate(:review, video: video, created_at: 1.days.ago)
      r3 = Fabricate(:review, video: video, created_at: 1.years.ago)
      expect(video.ordered_reviews).to eq([r2, r1, r3])
    end
  end

  describe "count_reviews" do
    let(:video) {Fabricate :video}

    it "should return 0 if there are no reviews" do
      expect(video.count_reviews).to eq(0)
    end

    it "should return 1 if there is only one review" do
      Fabricate(:review, video: video)
      expect(video.count_reviews).to eq(1)
    end

    it "should return 3 if there are 3 reviews" do
      3.times { Fabricate(:review, video: video)}
      expect(video.count_reviews).to eq(3)
    end
  end

  describe "sum_review_ratings" do
    let(:video) {Fabricate :video}

    it "should return 0 if there are no reviews" do
      expect(video.sum_review_ratings).to eq(0)
    end

    it "should return 4 if there is one review with a rating of 4" do
      Fabricate(:review, video: video, rating: 4)
      expect(video.sum_review_ratings).to eq(4)
    end

    it "should return 15 if there are five reviews with ratings of 1,2,3,4, and 5" do
      (1..5).each do |i|
        Fabricate(:review, video: video, rating: i)
      end
      expect(video.sum_review_ratings).to eq(15)
    end
  end

  describe "average_rating_of_reviews" do
    let(:video) {Fabricate :video}

    it "returns nil if there are no reviews" do
      expect(video.average_rating_of_reviews).to be_nil
    end

    it "returns 1.0 if there is only one review with a rating of 1" do
      Fabricate(:review, video: video, rating: 1)
      expect(video.average_rating_of_reviews).to eq(1.0)
    end

    it "returns 3.3 if there are 4 reviews with a rating of 3, 3, 3, and 4 respectively" do
      [3,3,3,4].each do |i|
        Fabricate(:review, video: video, rating: i)
      end
      expect(video.average_rating_of_reviews).to eq(3.3)
    end

    it "returns 3.7 if there are 3 reviews with a rating of 3, 4, and 4 respectively" do
      [3,4,4].each do |i|
        Fabricate(:review, video: video, rating: i)
      end
      expect(video.average_rating_of_reviews).to eq(3.7)
    end
  end
  
  describe "user_reviewed?(user)" do
    let(:user) {Fabricate(:user)}
    let(:video) {Fabricate(:video)}
    it "returns false if user has not reviewed video yet" do
      expect(video.user_reviewed?(user)).to eq(false)
    end

    it "returns true if user has reviewed video already" do
      video.reviews.create(rating: 5, review: "A review.", user: user)
      expect(video.user_reviewed?(user)).to eq(true)
    end
  end
end