# frozen_string_literal: true

class GenresController < ApplicationController
  def index
    @genres = Genre.order(:name)
    respond_to do |format|
      format.json
    end
  end

  def create
    @new = true
    if Genre.exists?(name: params[:genre][:name].to_s)
      @new = false
    else
      @genre = Genre.create(genre_params)
      @new = false unless @genre.valid?
    end

    respond_to do |format|
      format.js
    end
  end

private

  def genre_params
    params.require(:genre).permit(:name)
  end
end
