class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    @comment = current_user.comments.build comment_params
    if @comment.save
      flash[:success] = t :commentcreated
      redirect_to :back
    else
      flash[:danger] = t :cannotcomment
      redirect_to :back
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html {redirect_to review_path}
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    if @comment.update_attributes comment_params
      flash[:success] = t :commentupdated
      redirect_to :back
    else
      flash[:danger] = t :cannotcomment
      redirect_to :back
    end
  end

  private
  def comment_params
    params.require(:comment).permit :content, :review_id
  end

end
