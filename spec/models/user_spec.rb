require 'spec_helper'

describe User do
  it_validates_presence_of_set :full_name, :password, :email
  it { should validate_uniqueness_of(:email)}
  it { should have_many :reviews }
  it { should have_many(:queue_items).order(:position)}
end