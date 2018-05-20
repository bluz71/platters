# frozen_string_literal: true

class Users::CommentsController < ApplicationController
  before_action :set_user

  def index
    @comments = @user.comments.list.page(params[:page])
    @comments_path = request.path + "/comments"
    respond_to do |format|
      format.html
      format.json
    end
  end

  # AJAX end point to retrieve the next page of user comments.
  def comments
    @comments = @user.comments.list.page(params[:page])
    render partial: "comments/comment", layout: false,
           collection: @comments, locals: {with_posted_in: true}
  end

  private

    def set_user
      @user = User.friendly.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      if request.format.html?
        flash[:alert] = "User #{params[:user_id]} does not exist"
        redirect_to root_path
      else # JSON end-point
        head :not_found
      end
    end
end
