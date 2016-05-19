class AlbumsController < ApplicationController
  def index
    if params[:by_letter]
      @albums = Album.by_letter(params[:by_letter]).page(params[:page]).per(30)
    else
      @albums = Album.order(:title).page(params[:page]).per(30)
    end
  end
end
