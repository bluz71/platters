class ArtistsController < ApplicationController
  def index
    @artists = Artist.all.page(params[:page])
  end

  def show
    @artist = Artist.find(params[:id])
  end
end
