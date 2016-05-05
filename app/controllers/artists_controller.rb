class ArtistsController < ApplicationController
  def index
    @artists = Artist.all.page(params[:page])
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

  private

    def artist_params
      params.require(:artist).permit(:name, :description, :wikipedia, :website)
    end
end
