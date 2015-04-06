class VideosController < ApplicationController

  def index
    @categories = Category.all.sort{|x,y| x.name <=> y.name}
  end

  def show
    @video = Video.find(params[:id])
  end
end