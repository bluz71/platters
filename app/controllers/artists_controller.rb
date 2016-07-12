class ArtistsController < ApplicationController
  before_action :set_artist, only: [:show, :edit, :update, :destroy, :albums]

  def index
    if params[:letter]
      @artists = Artist.letter_prefix(params[:letter]).page(params[:page])
    elsif params[:digit]
      @artists = Artist.digit_prefix.page(params[:page])
    else
      @artists = Artist.order(:name).page(params[:page])
    end
  end

  def show
    @albums = Album.artist_albums(@artist.id)
  end

  def new
    @artist = Artist.new
    @back_link = request.referer || artists_path
  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      flash[:notice] = "#{@artist.name} has been created"
      redirect_to @artist
    else
      flash.now[:alert] = "Artist could not be created"
      @back_link = artists_path
      render "new"
    end
  end

  def edit
    @back_link = artist_path(@artist)
  end

  def update
    if @artist.update(artist_params)
      flash[:notice] = "#{@artist.name} has been updated"
      redirect_to @artist
    else
      flash.now[:alert] = "Artist could not be updated"
      @back_link = artists_path
      render "edit"
    end
  end

  def destroy
    @artist.destroy!
    flash[:notice] = "#{@artist.name} has been removed"
    redirect_to artists_path
  end

  def albums
    @albums = Album.artist_albums(@artist.id, params)
    @filter_name = if params[:newest]
                     "newest"
                   elsif params[:oldest]
                     "oldest"
                   elsif params[:name]
                     "name"
                   end
    respond_to do |format|
      format.js
    end
  end

  private

    def set_artist
      @artist = Artist.friendly.find(params[:id])
    end

    def artist_params
      params.require(:artist).permit(:name, :description, :wikipedia, :website)
    end
end
