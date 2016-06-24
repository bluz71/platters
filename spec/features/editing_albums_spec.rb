require "rails_helper"

RSpec.feature "Editing albums" do
  context "from artist page with new" do
    scenario "title"
    scenario "genre"
    scenario "year"
    scenario "track list"
  end

  context "from album page with new" do
    scenario "title"
    scenario "genre"
    scenario "year"
    scenario "track list"
  end

  context "will fail" do
    scenario "with blank title"
    scenario "when year greater than current year"
    scenario "when track listing is invalid"
  end

  context "when cancelled from artist page" do
    scenario "goes back"
    scenario "goes back after validation error"
  end

  context "when cancelled from album page" do
    scenario "goes back"
    scenario "goes back after validation error"
  end
end
