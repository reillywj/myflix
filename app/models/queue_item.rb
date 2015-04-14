class QueueItem < ActiveRecord::Base
  validates_presence_of :position, :video, :user
  belongs_to :user
  belongs_to :video
end