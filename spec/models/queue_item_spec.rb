require "spec_helper"

describe QueueItem do
  it_validates_presence_of_set :video, :user, :position
  it { should validate_numericality_of(:position).only_integer}
  it_belongs_to_set :user, :video

  let(:video) {Fabricate :video}
  let(:queue_item) {Fabricate :queue_item, video: video}

  describe "#video_title" do
    it "returns title of video" do
      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe "#rating" do
    it "returns nil if user has not rated video" do
      expect(queue_item.rating).to be_nil
    end

    it "returns the rating if a user has rated the video" do
      review = Fabricate(:review, user: queue_item.user, video: video)
      expect(queue_item.rating).to eq(review.rating)
    end
  end

  describe "#category" do
    it "returns a videos category" do
      expect(queue_item.category).to eq(video.category)
    end
  end

  describe "#category_name" do
    it "returns the category name of the video" do
      expect(queue_item.category_name).to eq(video.category.name)
    end
  end

  describe "#rating=" do
    it "updates prior review if there's already a review by the user" do
      video.reviews.create(rating: 5, review: "Bestest evar!", user: queue_item.user)
      queue_item.rating = 3
      expect(queue_item.rating).to eq(3)
    end

    it "clears the review if the rating is not present" do
      video.reviews.create(rating: 5, review: "Bestest evar!", user: queue_item.user)
      queue_item.rating = nil
      expect(queue_item.rating).to be_nil
    end

    it "creates a new review if there is not a review already by the user" do
      queue_item.rating = 1
      expect(queue_item.rating).to eq(1)
    end
  end
end