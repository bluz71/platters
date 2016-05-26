class Track < ActiveRecord::Base
  belongs_to :album

  validates :title, presence: true
  validates :number, numericality: {greater_than: 0, less_than: 150}

  # Return duration in a displayable form.
  def duration_display
    return @duration_display if @duration_display
    mins, secs = duration.divmod(60)
    @duration_display = "#{mins}:#{secs.to_s.rjust(2, "0")}"
  end
end
