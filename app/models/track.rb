# frozen_string_literal: true

class Track < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :album, counter_cache: true, touch: true

  validates :title, presence: true
  validates :number, numericality: {greater_than: 0, less_than: 200}

  # VALIDATIONS
  VALID_TRACK_RE = /\A(.+) \((\d+:\d\d)\)\z/

  # Return duration in a displayable form.
  def duration_display
    return @duration_display if @duration_display
    mins, secs = duration.divmod(60)
    @duration_display = "#{mins}:#{secs.to_s.rjust(2, '0')}"
  end

  # Called from Album#track_list_format, this method will parse a track line of
  # a submitted album form.
  #
  # The track line should contain the duration in parenthesis as in the
  # following example:
  #
  #  This is a track (5:26)
  def self.parse_form_track(track, index, tracks, errors)
    matches = VALID_TRACK_RE.match(track)
    unless matches
      errors.add(:track_list,
                 "format error, #{index.ordinalize} track is either " \
                 "missing: duration at the end of the line, or a "    \
                 "whitespace before the duration")
      return
    end

    parse_track_duration(matches, index, tracks, errors)
  end

  def self.parse_track_duration(matches, index, tracks, errors)
    mins, secs = matches[2].split(":")
    if secs.to_i < 60
      tracks << Track.new(title: matches[1], number: index,
                          duration: (mins.to_i * 60) + secs.to_i)
    else
      errors.add(:track_list,
                 "duration error, seconds can't exceed 59 for the " \
                 "#{index.ordinalize} track")
    end
  end
end
