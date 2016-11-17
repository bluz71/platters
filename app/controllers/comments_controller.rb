# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :require_login

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save!
    respond_to do |format|
      format.html { redirect_to @commentable_path }
      format.js
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end
end
