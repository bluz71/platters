require "rails_helper"

RSpec.feature "Listing artists" do
  context "with a small collection" do
    let!(:artist1) do
      FactoryGirl.create(:artist, name: "ABC", description: "ABC description")
    end

    let!(:artist2) do
      FactoryGirl.create(:artist, name: "XYZ", description: "XYZ description")
    end

    scenario "successfully" do
      visit artists_path
      expect(page).to have_selector "div.artist h2", text: "ABC"
      expect(page).to have_selector "div.artist", text: "ABC description"
      expect(page).to have_selector "div.artist h2", text: "XYZ"
      expect(page).to have_selector "div.artist", text: "XYZ description"
    end
  end

  context "with a large collection" do
    before do
      FactoryGirl.create(:artist, name: "ABC")
      25.times { FactoryGirl.create(:artist) }
      FactoryGirl.create(:artist, name: "XYZ")
    end

    scenario "will successfully paginate" do
      visit artists_path
      expect(page).to have_selector "div.artist h2", text: "ABC"
      expect(page).not_to have_selector "div.artist h2", text: "XYZ"
      click_on "Next"
      expect(page).not_to have_selector "div.artist h2", text: "ABC"
      expect(page).to have_selector "div.artist h2", text: "XYZ"
    end
  end

  context "filtered by" do
    scenario "letter successfully"
    scenario "letter with no matches"
    scenario "all will list every artist"
    scenario "searching successfully"
    scenario "searching with no matches"
  end
end
