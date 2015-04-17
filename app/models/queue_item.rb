class QueueItem < ActiveRecord::Base
  validates_presence_of :position, :video, :user
  validates_numericality_of :position, {only_integer: true}
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video
  delegate :name, to: :category, prefix: :category

  def rating
    review.rating if review
  end

  def rating=(new_rating)

    if review
      review.update_column(:rating, new_rating)
    else
      new_review = Review.new(user: user, video: video, rating: new_rating)
      new_review.save(validate: false)
    end
  end

  private

  def review
    @review ||= Review.where(user: user, video: video).first
  end
end