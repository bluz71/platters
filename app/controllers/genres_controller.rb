# frozen_string_literal: true

class GenresController < ApplicationController
  def create
    @new = true
    if Genre.exists?(params[:genre][:name])
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
