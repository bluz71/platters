# frozen_string_literal: true

module CommentsHelper
  def destroy_path(comment)
    if comment.commentable_type == "Album"
      artist_album_comment_path(comment.commentable.artist, comment.commentable, comment)
    elsif comment.commentable_type == "Artist"
      artist_comment_path(comment.commentable, comment)
    end
  end
end
