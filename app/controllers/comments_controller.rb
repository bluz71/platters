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

  private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def require_login_for_js
      render "comments/require_login" unless signed_in?
    end
end
