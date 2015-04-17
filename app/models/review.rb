class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates_presence_of :rating, :video, :user, :review
  validates_numericality_of :rating, greater_than_or_equal_to: 1, less_than_or_equal_to: 5
  validates_uniqueness_of :user_id, scope: :video_id
end