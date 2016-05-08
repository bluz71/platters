class ArtistsController < ApplicationController
  def index
    @artists = Artist.order(:name).page(params[:page])
  end

  def show
    @artist = Artist.find(params[:id])
  end

  def new
    @artist = Artist.new
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
  end

  def update
    @artist = Artist.find(params[:id])
    if @artist.update(artist_params)
      flash[:notice] = "#{@artist.name} has been updated"
      redirect_to @artist
    else
      flash.now[:alert] = "Artist could not be updated"
      render "new"
    end
  end

  def destroy
    @artist = Artist.find(params[:id])
    artist_name = @artist.name
    @artist.destroy!
    flash[:notice] = "#{artist_name} has been removed"
    redirect_to artists_url
  end

  private

    def artist_params
      params.require(:artist).permit(:name, :description, :wikipedia, :website)
    end
end
