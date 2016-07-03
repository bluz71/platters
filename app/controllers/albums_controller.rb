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
    @back_link = artist_path(@artist)
  end

  def create
    @artist = Artist.find(params[:artist_id])
    @album = @artist.albums.new(album_params)
    if @album.save
      flash[:notice] = "#{@album.title} has been created"
      redirect_to [@artist, @album]
    else
      flash.now[:alert] = "Album could not be created"
      @back_link = artist_path(@artist)
      render "new"
    end
  end

  def edit
    @album = Album.find(params[:id])
    @artist = @album.artist
    @back_link = request.referer || artist_path(@artist)
  end

  def update
    @artist = Artist.find(params[:artist_id])
    @album = @artist.albums.find(params[:id])
    if @album.update(album_params)
      flash[:notice] = "#{@album.title} has been updated"
      redirect_to [@artist, @album]
    else
      flash.now[:alert] = "Album could not be updated"
      @back_link = artist_path(@artist)
      render "edit"
    end
  end

  def destroy
    @album = Album.find(params[:id])
    artist = @album.artist
    album_title = @album.title
    @album.destroy!
    respond_to do |format|
      format.html do
        flash[:notice] = "#{album_title} has been removed"
        redirect_to artist_path(artist)
      end
      format.js
    end
  end

  private

    def album_params
      params.require(:album).permit(:title, :genre_id, :year, :track_list, :cover) 
    end
end
