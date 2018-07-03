require "rails_helper"

RSpec.describe "Editing artists", type: :system do
  let!(:artist) { FactoryBot.create(:artist, name: "ABC") }
  let(:admin) { FactoryBot.create(:admin) }

  context "access" do
    it "is disallowed for anonymous users" do
      visit edit_artist_path(artist)
      expect(page).to have_content "Administrator rights are required for this action"
    end

    it "is disallowed for non-administrator users" do
      user = FactoryBot.create(:user)
      visit edit_artist_path(artist, as: user.id)
      expect(page).to have_content "Administrator rights are required for this action"
    end
  end

  context "with new" do
    before do
      visit artist_path(artist, as: admin.id)
      click_on "Edit"
    end

    it "name" do
      fill_in "Name", with: "CBA"
      click_on "Submit"

      artist.reload
      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "CBA has been updated"
      expect(page).to have_title "CBA"
      expect(page).to have_selector "div#artist h1", text: "CBA"
    end

    it "wikepedia link" do
      fill_in "Wikipedia", with: "XYZ"
      click_on "Submit"

      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "ABC has been updated"
      expect(page).to have_link "Wikipedia", href: "https://www.wikipedia.org/wiki/XYZ"
    end

    it "website link" do
      fill_in "Website", with: "http://www.xyz.net"
      click_on "Submit"

      expect(current_path).to eq artist_path(artist)
      expect(page).to have_content "ABC has been updated"
      expect(page).to have_link "xyz.net", href: "http://www.xyz.net"
    end

    it "description" do
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

    it "with blank name" do
      fill_in "Name", with: ""
      click_on "Submit"

      expect(page).to have_content "Artist could not be updated"
      expect(page).to have_content "Name can't be blank"
      expect(page).to have_selector "div.page-header h1", text: "Edit Artist"
    end

    it "when using an existing artist name" do
      FactoryBot.create(:artist, name: "XYZ")

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

    it "goes back" do
      click_on "Cancel"

      expect(current_path).to eq(artist_path(artist))
    end

    it "goes back after validation error" do
      fill_in "Name", with: ""
      click_on "Submit"
      click_on "Cancel"

      expect(current_path).to eq(artists_path)
    end
  end
end
