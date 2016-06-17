class ArtistsController < ApplicationController
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
    @artist = Artist.find(params[:id])
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
      render "new"
    end
  end

  def edit
    @artist = Artist.find(params[:id])
    @back_link = artist_path(@artist)
  end

  def update
    @artist = Artist.find(params[:id])
    if @artist.update(artist_params)
      flash[:notice] = "#{@artist.name} has been updated"
      redirect_to @artist
    else
      flash.now[:alert] = "Artist could not be updated"
      render "edit"
    end
  end

  def destroy
    @artist = Artist.find(params[:id])
    artist_name = @artist.name
    @artist.destroy!
    flash[:notice] = "#{artist_name} has been removed"
    redirect_to artists_path
  end

  private

    def artist_params
      params.require(:artist).permit(:name, :description, :wikipedia, :website)
    end
end
