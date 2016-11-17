# frozen_string_literal: true

class Albums::CommentsController < CommentsController
  before_action :set_commentable

  private

    def set_commentable
      artist = Artist.friendly.find(params[:artist_id])
      @commentable = artist.albums.friendly.find(params[:album_id])
      @commentable_path = artist_album_path(artist, @commentable)
    end
end
