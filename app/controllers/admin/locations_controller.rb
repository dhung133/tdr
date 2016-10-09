class Admin::LocationsController < ApplicationController
  load_and_authorize_resource

  def index
    @locations = Location.paginate page: params[:page]
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new location_params
    if @location.save
      flash[:success] = t :success
      redirect_to admin_locations_path
    else
      render :new
    end
  end

  private
  def location_params
    params.require(:location).permit :name, :introduction, :category_id,
      :picture
  end
end