class Artist < ActiveRecord::Base
  has_many :albums

  # Return a link with the "http(s)://www" prefix stripped away.
  def website_link
    return unless website?
    @website_link ||= website.split("//")[1].split(".")[1..-1].join(".")
  end
end
