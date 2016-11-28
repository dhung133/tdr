class Admin::RequestsController < ApplicationController
  load_and_authorize_resource

  def index
    @requests = (Request.order created_at: :desc)
      .page(params[:page]).per_page(10)
  end

  def show
  end

  def update
    @request = Request.find params[:id]
    if @request.update_attributes status: params[:status]
      if @request.accepted?
        flash[:info] = t "requests.accepted"
      else
        flash[:info] = "requests.denied"
      end
    else
      flash[:warning] = t "requests.update_fail"
    end
    redirect_to admin_requests_path
  end

  def destroy
    @request = Request.find(params["id"])
    if @request.destroy
      flash[:success] = t "requests.destroy"
    else
      flash[:error] = t "requests.destroy_fail"
    end
    redirect_to admin_requests_path
  end
end
