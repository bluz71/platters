# frozen_string_literal: true

module AlbumsHelper
  def genre_select(album)
    album.genre.present? ? album.genre.id : Genre.find_by(name: "Rock").id
  end

  def filter_visibility
    "hidden" unless params.key?("filter") && params["filter"] == "true"
  end

  def track_transparency(index, count)
    return "no-transparency"    if count <= 200
    return "light-transparency" if index == 19
    return "mid-transparency"   if index == 20
  end
end
