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

  def create
    @artist = Artist.find(params[:artist_id])
    @album = @artist.albums.new(album_params)
    if @album.save
      flash[:notice] = "#{@album.title} has been created"
      redirect_to @artist
    else
      flash.now[:alert] = "Album could not be created"
      render "new"
    end
  end

  def edit
    @album = Album.find(params[:id])
    @artist = @album.artist
  end

  private

    def album_params
      params.require(:album).permit(:title, :genre_id, :year, :tracks_list) 
    end
end
