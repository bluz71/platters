require "rails_helper"

RSpec.feature "Listing artists" do
  let!(:artist1) { FactoryGirl.create(:artist) }
  let!(:artist2) do
    FactoryGirl.create(:artist, name: "XYZ", description: "XYZ description")
  end

  scenario "successfully" do
    visit artists_path
    expect(page).to have_selector "div.platter h2", text: "ABC"
    expect(page).to have_selector "div.platter", text: "The description"
    expect(page).to have_selector "div.platter h2", text: "XYZ"
    expect(page).to have_selector "div.platter", text: "XYZ description"
  end
end
