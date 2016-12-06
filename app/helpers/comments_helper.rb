# frozen_string_literal: true

module CommentsHelper
  def destroy_path(comment)
    if comment.commentable_type == "Album"
      artist_album_comment_path(comment.commentable.artist, comment.commentable, comment)
    elsif comment.commentable_type == "Artist"
      artist_comment_path(comment.commentable, comment)
    end
  end

  def posted_in(comment, with_posted_in)
    return unless with_posted_in

    content_tag(:small) do
      if comment.commentable_type == "Album"
        album = comment.commentable
        artist = album.artist
        concat " posted in "
        concat artist.name
        concat " / "
        concat link_to(album.title, artist_album_path(artist, album, anchor: "comments"))
      elsif comment.commentable_type == "Artist"
        concat " posted in "
        concat link_to(comment.commentable.name, artist_path(comment.commentable, anchor: "comments"))
      end
    end
  end
end
