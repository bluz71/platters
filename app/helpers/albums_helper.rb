# frozen_string_literal: true

module AlbumsHelper
  def genre_select(album)
    album.genre.present? ? album.genre.id : Genre.find_by(name: "Rock").id
  end
end
