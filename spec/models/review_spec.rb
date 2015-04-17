require "spec_helper"

describe Review do
  it { should belong_to(:video) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:rating)}
  it { should validate_presence_of(:video)}
  it { should validate_presence_of(:user)}
  it { should validate_presence_of :review }
  it { should validate_uniqueness_of(:user_id).scoped_to(:video_id)}
  it { should validate_numericality_of(:rating).is_greater_than_or_equal_to(1)}
  it { should validate_numericality_of(:rating).is_less_than_or_equal_to(5)}
end