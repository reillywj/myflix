class CategoriesController < ApplicationController
  before_action :require_user_logged_in

  def show
    @category = Category.find(params[:id])
  end
end