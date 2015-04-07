class VideosController < ApplicationController

  def index
    @categories = Category.all.sort{|x,y| x.name <=> y.name}
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @results = Video.search_by_title(params[:search_term])
    if @results.size == 1
      @video = @results.first
      render :show
    else
      render :search
    end
  end
end