require 'spec_helper'

describe Video do
  it { should belong_to(:category)}
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
  
end