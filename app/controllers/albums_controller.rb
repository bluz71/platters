class AlbumsController < ApplicationController
  def index
    @albums = Album.order(:title).page(params[:page]).per(30)
  end
end
