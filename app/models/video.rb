class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews

  validates_presence_of :title, :description, :category

  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def ordered_reviews
    reviews.order(created_at: :desc)
  end

  def count_reviews
    reviews.count
  end

  def sum_review_ratings
    sum = 0
    reviews.each {|review| sum += review.rating}
    return sum
  end

  def average_rating_of_reviews
    return nil if reviews.empty?
    return (sum_review_ratings.to_f / count_reviews).round(2)
  end
end