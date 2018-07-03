require "rails_helper"

RSpec.describe "Removing artists", type: :system do
  let!(:artist1) { FactoryBot.create(:artist, name: "ABC") }
  let!(:artist2) { FactoryBot.create(:artist, name: "XYZ") }
  let(:admin) { FactoryBot.create(:admin) }

  context "access" do
    it "is disallowed for anonymous users" do
      page.driver.delete(artist_path(artist1))
      expect(Artist.exists?(artist1.id)).to be_truthy
    end

    it "is disallowed for non-administrator users" do
      user = FactoryBot.create(:user)
      page.driver.delete(artist_path(artist1, as: user.id))
      expect(Artist.exists?(artist1.id)).to be_truthy
    end
  end

  it "successfully" do
    visit artist_path(artist1, as: admin.id)
    click_on "Remove"

    expect(current_path).to eq artists_path
    expect(page).to have_content "ABC has been removed"
    expect(page).not_to have_selector "div#artist h2", text: "ABC"
    expect(page).to have_selector "div.artist h2", text: "XYZ"
  end
end
