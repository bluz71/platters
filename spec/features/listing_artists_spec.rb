require "rails_helper"

RSpec.feature "Listing artists" do
  context "with a small collection" do
    before do
      FactoryGirl.create(:artist, name: "ABC", description: "ABC description")
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

  context "by search" do
    before do
      FactoryGirl.create(:artist, name: "ABC", description: "ABC 123 description")
      FactoryGirl.create(:artist, name: "DEF", description: "123 description")
      FactoryGirl.create(:artist, name: "XYZ", description: "XYZ description")
      visit artists_path
    end

    it "with matches", js: true do
      page.find(".search-link").click
      wait_for_js
      fill_in "search", with: "ABC"
      page.find(".search-submit").click
      artists = page.all(".artist")
      expect(artists.size).to eq 1
      expect(artists[0]).to have_content("ABC")
    end

    it "rankes name matches higher than description matches", js: true do
      page.find(".search-link").click
      wait_for_js
      fill_in "search", with: "123"
      page.find(".search-submit").click
      artists = page.all(".artist")
      expect(artists.size).to eq 2
      expect(artists[0]).to have_content("ABC")
      expect(artists[1]).to have_content("DEF")
    end

    it "with no matches", js: true do
      page.find(".search-link").click
      wait_for_js
      fill_in "search", with: "foobar"
      page.find(".search-submit").click
      expect(page.all(".artist").size).to eq 0
    end
  end

  context "by letter" do
    before do
      FactoryGirl.create(:artist, name: "ABC")
      visit artists_path
    end

    it "with matches" do
      click_on "A"

      albums = page.all(".artist")
      expect(albums.size).to eq 1
      expect(albums[0]).to have_content("ABC")
    end

    it "with no matches" do
      click_on "B"

      albums = page.all(".artist")
      expect(albums.size).to eq 0
    end
  end

  context "has a sidebar" do
    it "that lists newest albums"
  end
end
