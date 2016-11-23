# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :require_login_for_js

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save!
    @anchor = "#comment-#{@comment.id}"
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    respond_to do |format|
      format.js
    end
  rescue ActiveRecord::RecordNotFound
    @message = "You do not have permission to destroy that comment"
    render "comments/flash"
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def require_login_for_js
      @message = "Please log in to comment"
      render "comments/flash" unless signed_in?
    end
end
