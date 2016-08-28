module AlbumsHelper
  def genre_select(album)
    album.genre.present? ? album.genre.id : Genre.find_by(name: "Rock").id
  end

  def filter_visibility
    "hidden" unless params.key?("filter") && params["filter"] == "true"
  end
end
