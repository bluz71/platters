require "rails_helper"

RSpec.feature "Removing artists" do
  let!(:artist1) { FactoryGirl.create(:artist) }
  let!(:artist2) { FactoryGirl.create(:artist, name: "XYZ") }

  before do
    visit artist_path(artist1)
  end

  scenario "successfully" do
    click_on "Remove"

    expect(current_path).to eq artists_path
    expect(page).to have_content "ABC has been removed"
    expect(page).not_to have_selector "div#platter h2", text: "ABC"
    expect(page).to have_selector "div.platter h2", text: "XYZ"
  end
end
