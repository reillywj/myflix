class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items,-> {order :position}
  validates_presence_of :full_name, :email, :password
  validates_uniqueness_of :email

  def update_queue_positions
    queue_items.each_with_index do |item, index|
      item.update_attributes(position: index + 1)
    end
  end

  def number_of_queue_items
    queue_items.count
  end

  def queue(video)
    queue_items.create(video: video, position: new_queue_item_position)
  end

  def has_queued?(video)
    queue_items.where(video: video).size > 0
  end

  private

  def new_queue_item_position
    number_of_queue_items + 1
  end


end