class QueueItem < ActiveRecord::Base
  validates_presence_of :position, :video, :user
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video
  delegate :name, to: :category, prefix: :category

  def rating
    review = Review.where(user: user, video: video).first
    review.rating if review
  end
end