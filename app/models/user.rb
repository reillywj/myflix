class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items
  validates_presence_of :full_name, :email, :password
  validates_uniqueness_of :email

  def queue_items
    super.order(:position)
  end
end