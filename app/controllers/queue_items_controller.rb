class QueueItemsController < ApplicationController
  before_action :require_user_logged_in
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_path
  end

  def destroy
    queue_item_to_delete = QueueItem.find(params[:id])
    if current_user_queue_items.include?(queue_item_to_delete)
      queue_item_to_delete.destroy
    else
      flash[:danger] = "You can't do that."
    end
    update_positions(current_user_queue_items)
    redirect_to my_queue_path
  end

  private

  def queue_video(video)
    if current_user_has_queued_video?(video)
      flash[:warning] = "You have already queued #{video.title}."
    else
      flash[:success] = "You have added #{video.title} to your queue."
      QueueItem.create(video: video, user: current_user, position: new_queue_item_position)
    end
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_has_queued_video?(video)
    current_user.queue_items.where(video: video).size > 0
  end

  def update_positions(queue)
    start = 1
    queue.each do |item|
      item.position = start
      start += 1
      item.save
    end
  end
  def current_user_queue_items
    current_user.queue_items
  end
end