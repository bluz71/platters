# frozen_string_literal: true

class Users::CommentsController < ApplicationController
  before_action :set_user

  def index
    @comments = @user.comments.list.page
    @comments_path = request.path + "/comments"
  end

  # AJAX end point to retrieve the next page of user comments.
  def comments
    @comments = @user.comments.list.page(params[:page])
    render partial: "comments/comment", layout: false, collection: @comments, locals: {with_posted_in: true}
  end

  private

    def set_user
      @user = User.friendly.find(params[:user_id])
    end
end
