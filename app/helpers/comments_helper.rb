# frozen_string_literal: true

module CommentsHelper
  def destroy_path(comment)
    if comment.album?
      artist_album_comment_path(comment.commentable.artist, comment.commentable, comment)
    else
      artist_comment_path(comment.commentable, comment)
    end
  end

  def posted_in(comment, with_posted_in)
    return unless with_posted_in

    content_tag(:small) do
      if comment.album?
        album = comment.commentable
        artist = album.artist
        concat " posted in "
        concat artist.name
        concat " / "
        concat link_to(album.title, artist_album_path(artist, album, anchor: "comments"))
      else
        concat " posted in "
        concat link_to(comment.commentable.name, artist_path(comment.commentable, anchor: "comments"))
      end
    end
  end
end
