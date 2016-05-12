class AlbumsController < ApplicationController
  def index
    @albums = Album.order(:title).page(params[:page])
  end
end
