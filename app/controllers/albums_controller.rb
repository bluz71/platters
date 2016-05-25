class AlbumsController < ApplicationController
  def index
    if params[:by_letter]
      @albums = Album.by_letter(params[:by_letter]).page(params[:page]).per(20)
    elsif params[:by_digit]
      @albums = Album.by_digit.page(params[:page]).per(20)
    else
      @albums = Album.order(:title).page(params[:page]).per(20)
    end
  end

  def show
    @album = Album.find(params[:id])
  end
end
