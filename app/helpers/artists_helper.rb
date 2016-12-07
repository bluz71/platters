# frozen_string_literal: true

module ArtistsHelper
  def commentable_path(comment)
    if comment.commentable_type == "Album"
      artist_album_path(comment.commentable.artist, comment.commentable, anchor: "comments")
    elsif comment.commentable_type == "Artist"
      artist_path(comment.commentable, anchor: "comments")
    end
  end

  def commentable_name(comment)
    name = ""

    if comment.commentable_type == "Album"
      name += comment.commentable.title
    elsif comment.commentable_type == "Artist"
      name += comment.commentable.name
    end

    name
  end
end
