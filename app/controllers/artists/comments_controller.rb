# frozen_string_literal: true

class Artists::CommentsController < CommentsController
  before_action :set_commentable

  private

  def set_commentable
    @commentable = Artist.friendly.find(params[:artist_id])
    @commentable_path = artist_path(@commentable)
  end
end
