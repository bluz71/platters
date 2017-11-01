# frozen_string_literal: true

class ArtistsController < ApplicationController
  before_action :require_admin, except: [:index, :show, :albums]
  before_action :set_artist, only: [:show, :edit, :update, :destroy, :albums]

  def index
    @artists = Artist.list(params)
    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @albums        = Album.artist_albums(@artist.id)
    @comments      = @artist.comments.list.page
    @comments_path = request.path + "/comments"
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
    @artist.slug = nil
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

  private

    def set_artist
      @artist = Artist.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "The artist '#{params[:id]}' does not exist"
      redirect_to artists_path
    end

    def artist_params
      params.require(:artist).permit(:name, :description, :wikipedia, :website)
    end
end
