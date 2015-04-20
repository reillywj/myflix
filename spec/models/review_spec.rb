require "spec_helper"

describe Review do
  it_belongs_to_set :video, :user
  it_validates_presence_of_set :rating, :video, :user, :review
  it { should validate_uniqueness_of(:user_id).scoped_to(:video_id)}
  it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(1)}
  it { should validate_numericality_of(:rating).is_less_than_or_equal_to(5)}
end