class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    @comment = current_user.comments.build comment_params
    @comment.save
    respond_to do |format|
      format.html {redirect_to review_path}
      format.js
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html {redirect_to review_path}
      format.js
    end
  end

  def edit
  end

  def update
    if @comment.update_attributes comment_params
      flash[:success] = t :commentupdated
    else
      render :edit
    end
  end

  private
  def comment_params
    params.require(:comment).permit :content, :review_id
  end

end
