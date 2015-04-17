require "spec_helper"

describe QueueItem do
  it { should validate_presence_of :video}
  it { should validate_presence_of :user }
  it { should validate_presence_of :position }
  it { should validate_numericality_of(:position).only_integer}

  it { should belong_to :user }
  it { should belong_to :video }

  describe "#video_title" do
    it "returns title of video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq(video.title)
    end
  end

  describe "#rating" do
    let(:video) {Fabricate :video}
    let(:queue_item) {Fabricate(:queue_item, video: video)}
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
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(video.category)
    end
  end

  describe "#category_name" do
    it "returns the category name of the video" do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq(video.category.name)
    end
  end

  describe "#rating=" do
    let(:alice) {Fabricate :user}
    let(:video) {Fabricate :video}
    let(:queue_item) {Fabricate :queue_item, user: alice, video: video}
    
    it "updates prior review if there's already a review by the user" do
      video.reviews.create(rating: 5, review: "Bestest evar!", user: alice)
      queue_item.rating = 3
      expect(queue_item.rating).to eq(3)
    end

    it "clears the review if the rating is not present" do
      video.reviews.create(rating: 5, review: "Bestest evar!", user: alice)
      queue_item.rating = nil
      expect(queue_item.rating).to be_nil
    end

    it "creates a new review if there is not a review already by the user" do
      queue_item.rating = 1
      expect(queue_item.rating).to eq(1)
    end
  end
end