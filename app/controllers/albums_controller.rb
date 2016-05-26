class AlbumsController < ApplicationController
  def index
    if params[:by_letter]
      @albums = Album.includes(:artist, :genre, :release_date)
                     .by_letter(params[:by_letter]).page(params[:page]).per(20)
    elsif params[:by_digit]
      @albums = Album.includes(:artist, :genre, :release_date)
                     .by_digit.page(params[:page]).per(20)
    else
      @albums = Album.includes(:artist, :genre, :release_date)
                     .order(:title).page(params[:page]).per(20)
    end
  end

  def show
    @album = Album.find(params[:id])
  end
end
