class AlbumsController < ApplicationController
  def index
    if params[:letter]
      @albums = Album.includes(:artist, :genre, :release_date)
                     .letter_prefix(params[:letter]).page(params[:page]).per(20)
    elsif params[:digit]
      @albums = Album.includes(:artist, :genre, :release_date)
                     .digit_prefix.page(params[:page]).per(20)
    else
      @albums = Album.includes(:artist, :genre, :release_date)
                     .order(:title).page(params[:page]).per(20)
    end
  end

  def show
    @album = Album.find(params[:id])
    @artist = @album.artist
    @tracks = @album.tracks
  end

  def new
    @artist = Artist.find(params[:artist_id])
    @album = @artist.albums.new
  end
end
