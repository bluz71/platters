require "rails_helper"

RSpec.feature "Editing artists" do
  let!(:artist) { FactoryGirl.create(:artist, name: "ABC") }
  let(:admin) { FactoryGirl.create(:admin) }

  context "access" do
    scenario "is disallowed for anonymous users" do
      visit edit_artist_path(artist)
      expect(page).to have_content "Administrator rights are required for this action"
    end

    scenario "is disallowed for non-administrator users" do
      user = FactoryGirl.create(:user)
      visit edit_artist_path(artist, as: user.id)
      expect(page).to have_content "Administrator rights are required for this action"
    end
  end

  context "with new" do
    before do
      visit artist_path(artist, as: admin.id)
      click_on "Edit"
    end

    scenario "name" do
      fill_in "Name", with: "CBA"
      click_on "Submit"

      artist.reload
      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "CBA has been updated"
      expect(page).to have_title "CBA"
      expect(page).to have_selector "div#artist h1", text: "CBA"
    end

    scenario "wikepedia link" do
      fill_in "Wikipedia", with: "XYZ"
      click_on "Submit"

      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "ABC has been updated"
      expect(page).to have_link "Wikipedia", href: "https://www.wikipedia.org/wiki/XYZ"
    end

    scenario "website link" do
      fill_in "Website", with: "http://www.xyz.net"
      click_on "Submit"

      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "ABC has been updated"
      expect(page).to have_link "xyz.net", href: "http://www.xyz.net"
    end

    scenario "description" do
      fill_in "Description", with: "XYZ description"
      click_on "Submit"

      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "ABC has been updated"
      expect(page).to have_selector "div#artist .description", text: "XYZ description"
    end
  end

  context "will fail" do
    before do
      visit artist_path(artist, as: admin.id)
      click_on "Edit"
    end

    scenario "with blank name" do
      fill_in "Name", with: ""
      click_on "Submit"

      expect(page).to have_content "Artist could not be updated"
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_selector "div.page-header h1", text: "Edit Artist"
    end

    scenario "when using an existing artist name" do
      FactoryGirl.create(:artist, name: "XYZ") 

      fill_in "Name", with: "XYZ"
      click_on "Submit"

      expect(page).to have_content "Artist could not be updated"
      expect(page).to have_content "Name has already been taken"
    end
  end

  context "when cancelled" do
    before do
      visit artist_path(artist, as: admin.id)
      click_on "Edit"
    end

    scenario "goes back" do
      click_on "Cancel"

      expect(current_path).to eq(artist_path(artist))
    end

    scenario "goes back after validation error" do
      fill_in "Name", with: ""
      click_on "Submit"
      click_on "Cancel"

      expect(current_path).to eq(artists_path)
    end
  end
end
