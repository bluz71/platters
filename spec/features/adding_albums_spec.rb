require "rails_helper"

RSpec.feature "Adding albums" do
  context "when submitting" do
    scenario "with valid attributes"
    scenario "with blank name"
    scenario "with invalid tracks"
  end

  context "when cancelled" do
    scenario "goes back"
    scenario "goes back after validation error"
  end
end
