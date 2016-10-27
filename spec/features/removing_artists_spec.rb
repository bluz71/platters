require "rails_helper"

RSpec.feature "Removing artists" do
  let!(:artist1) { FactoryGirl.create(:artist, name: "ABC") }
  let!(:artist2) { FactoryGirl.create(:artist, name: "XYZ") }
  let(:admin) { FactoryGirl.create(:admin) }

  context "access" do
    scenario "is disallowed for anonymous users" do
      page.driver.delete(artist_path(artist1))
      expect(Artist.exists?(artist1.id)).to be_truthy
    end

    scenario "is disallowed for non-administrator users" do
      user = FactoryGirl.create(:user)
      page.driver.delete(artist_path(artist1, as: user.id))
      expect(Artist.exists?(artist1.id)).to be_truthy
    end
  end

  scenario "successfully" do
    visit artist_path(artist1, as: admin.id)
    click_on "Remove"

    expect(current_path).to eq artists_path
    expect(page).to have_content "ABC has been removed"
    expect(page).not_to have_selector "div#artist h2", text: "ABC"
    expect(page).to have_selector "div.artist h2", text: "XYZ"
  end
end
