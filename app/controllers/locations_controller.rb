class LocationsController < ApplicationController
  load_and_authorize_resource

  def index
    @search = Location.search(params[:q])
    @locations = @search.result.page(params[:page]).per_page(6)
    @categories = Category.all
  end

  def show
    @location = Location.find_by_id params[:id]
    @review = Review.new
    @reviews = @location.reviews.all.page(params[:page]).per_page(3)
    @comment = Comment.new
    @category = @location.category
    @suggestions = @category.locations.all_except(@location).limit(3)
  end
end
