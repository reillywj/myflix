class AddReviewColumnToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :review, :text
  end
end
