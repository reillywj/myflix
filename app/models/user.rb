class User < ActiveRecord::Base
  has_secure_password validations: false
  has_many :reviews
  validates_presence_of :full_name, :email, :password
  validates_uniqueness_of :email

end