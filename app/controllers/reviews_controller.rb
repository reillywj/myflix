class ReviewsController < ApplicationController
  before_action :require_user_logged_in

  def create
    @review = Review.new(params.require(:review).permit(:rating, :review))
    @video = Video.find(params[:video_id])
    @review.video = @video
    @review.user = current_user
    if @review.save
      flash[:success] = "You have reviewed #{@video.title}!"
      redirect_to video_path(@video)
    else
      unless @review.errors.messages[:user_id]
        flash[:danger] = "You must provide valid feedback."
      else
        flash[:danger] = "You have already reviewed this video."
        @review = Review.new
      end
      render "videos/show"
    end
  end
end