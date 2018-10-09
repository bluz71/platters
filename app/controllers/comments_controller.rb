# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :require_login_for_client, only: [:create, :destroy]

  # AJAX end point to retrieve the next page of artist or album comments.
  def index
    @comments = @commentable.comments.list.page(params[:page])
    respond_to do |format|
      format.html do
        render partial: "comments/comment", layout: false,
          collection: @comments, locals: {with_posted_in: false}
      end
      format.json
    end
  end

  def create
    @comment = @commentable.comments.new(body: comment_body)
    @comment.user = current_user
    if !@comment.valid?
      # Handle invalid comments.
      #
      # Note, this should not happen when using the web interface since the
      # "Post it" button will only be enabled when comments are a valid length
      # (that is between 1 and 280 characters long).
      @message = "Comment #{@comment.errors.messages[:body].first}"
      return render "comments/flash"
    elsif current_user.comments.today.count >= 100
      @message = "User limit of 100 comments per-day has been exceeded. "\
                 "Please resume commenting tomorrow."
      return render "comments/flash"
    end
    @comment.save!
    @anchor = "#comment-#{@comment.id}"
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @comment = if current_user.admin?
                 # Administrators can destroy any comments.
                 Comment.find(params[:id])
               else
                 # Normal users can only destroy their own comments.
                 current_user.comments.find(params[:id])
               end
    @comment.destroy!
    respond_to do |format|
      format.js
      format.json { head :ok }
    end
  rescue ActiveRecord::RecordNotFound
    delete_record_not_found
  end

  private

    def comment_body
      params[:comment][:body].gsub(/\r\n?/, "\n")
    end

    def require_login_for_client
      if request.format.json? && !signed_in?
        head :unauthorized
        return
      end

      @message = "Please log in to comment"
      render "comments/flash" unless signed_in?
    end

    def delete_record_not_found
      if request.format.html?
        head :not_found
      else
        @message = "Comment deletion failed due to permission or not found issue"
        render "comments/flash"
      end
    end
end
