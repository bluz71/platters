# frozen_string_literal: true

class Artists::AlbumsController < ApplicationController
  before_action :set_artist, only: [:index]

  def index
    @albums = Album.artist_albums(@artist.id, params)
    @order_name = if params[:newest]
                    "newest"
                  elsif params[:oldest]
                    "oldest"
                  elsif params[:longest]
                    "longest"
                  elsif params[:name]
                    "name"
                  end
    respond_to do |format|
      format.js
      format.json
    end
  end

private

  def set_artist
    @artist = Artist.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The artist '#{params[:id]}' does not exist"
    redirect_to artists_path
  end
end
