class QueueItemsController < ApplicationController
  before_action :require_user_logged_in
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item_to_delete = QueueItem.find(params[:id])
    if current_user.queue_items.include?(queue_item_to_delete)
      queue_item_to_delete.destroy
    else
      flash[:danger] = "You can't do that."
    end
    current_user.update_queue_positions
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_items
      current_user.update_queue_positions
    rescue ActiveRecord::RecordInvalid
      flash[:danger] = "Invalid position numbers."
    end

    redirect_to my_queue_path
  end

  private

  def queue(video)
    if current_user.has_queued?(video)
      flash[:warning] = "You have already queued #{video.title}."
    else
      flash[:success] = "You have added #{video.title} to your queue."
      current_user.queue(video)
    end
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data[:id])
        queue_item.update_attributes!(position: queue_item_data[:position]) if queue_item.user == current_user
      end
    end
  end
end