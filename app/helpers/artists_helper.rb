module ArtistsHelper
  def has_error?(artist, field)
    "has-error" if artist.errors[field].present?
  end
end
