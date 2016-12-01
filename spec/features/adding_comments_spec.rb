require "rails_helper"

RSpec.feature "Adding comments" do
  context "to artists" do
    scenario "is not possible for anonymous users"
    scenario "updates comment counter upon each key stroke"
    scenario "when posted with valid text"
    scenario "only stores newlines for comments containing returns"
    scenario "updates the timestamp for the artist"
    scenario "when posted will update comment count"
    scenario "when posted with text containing links"
    scenario "is not possible with a blank comment"
    scenario "is not possible with a comment longer than 280 characters"
  end

  context "to albums" do
    scenario "is not possible for anonymous users"
    scenario "updates comment counter upon each key stroke"
    scenario "when posted with valid text"
    scenario "only stores newlines for comments containing returns"
    scenario "updates the timestamp for the album"
    scenario "when posted will update comment count"
    scenario "when posted with text containing links"
    scenario "is not possible with a blank comment"
    scenario "is not possible with a comment longer than 280 characters"
  end
end
