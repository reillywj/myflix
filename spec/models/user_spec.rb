require 'spec_helper'

describe User do
  it { should validate_presence_of(:full_name) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email)}
  it { should have_many :reviews }
  it { should have_many :queue_items}

  describe "#queue_items" do
    let(:user) {Fabricate :user}
    it "returns [] if there are no queue_items" do
      expect(user.queue_items).to be_empty
    end
    it "returns an array of size one if there is only one queue item" do
      queue_item = Fabricate(:queue_item, user: user)
      expect(user.queue_items).to eq([queue_item])
    end
    it "returns an ordered array of queue items for more than one queue item" do
      queue_item1 = Fabricate(:queue_item, user: user, position: 3)
      queue_item2 = Fabricate(:queue_item, user:user, position: 1)
      queue_item3 = Fabricate(:queue_item, user: user, position: 2)
      expect(user.queue_items).to eq([queue_item2, queue_item3, queue_item1])
    end
  end
end