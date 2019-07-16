require "rails_helper"

RSpec.describe "Listing artists", type: :system do
  context "with a small collection" do
    before do
      FactoryBot.create(:artist, name: "ABC", description: "ABC description")
      FactoryBot.create(:artist, name: "XYZ", description: "XYZ description")
    end

    it "successfully" do
      visit artists_path
      expect(page).to have_selector "div.artist h2", text: "ABC"
      expect(page).to have_selector "div.artist", text: "ABC description"
      expect(page).to have_selector "div.artist h2", text: "XYZ"
      expect(page).to have_selector "div.artist", text: "XYZ description"
    end
  end

  context "with a large collection" do
    before do
      FactoryBot.create(:artist, name: "ABC")
      25.times { FactoryBot.create(:artist) }
      FactoryBot.create(:artist, name: "XYZ")
    end

    it "will successfully paginate" do
      visit artists_path
      expect(page).to     have_selector "div.artist h2", text: "ABC"
      expect(page).not_to have_selector "div.artist h2", text: "XYZ"
      click_on "Next"
      expect(page).not_to have_selector "div.artist h2", text: "ABC"
      expect(page).to     have_selector "div.artist h2", text: "XYZ"
    end
  end

  context "by search" do
    before do
      FactoryBot.create(:artist, name: "ABC", description: "ABC 123 description")
      FactoryBot.create(:artist, name: "DEF", description: "123 description")
      FactoryBot.create(:artist, name: "XYZ", description: "XYZ description")
      visit artists_path
    end

    it "with matches", js: true do
      Capybara.using_wait_time 5 do
        page.find(".search-link").click
        fill_in "search", with: "ABC"
      end
      page.find(".search-submit").click
      artists = page.all(".artist")
      expect(artists.size).to eq 1
      expect(artists[0]).to have_content "ABC"
    end

    it "rankes name matches higher than description matches", js: true do
      page.find(".search-link").click
      fill_in "search", with: "123"
      page.find(".search-submit").click
      artists = page.all(".artist")
      expect(artists.size).to eq 2
      expect(artists[0]).to have_content "ABC"
      expect(artists[1]).to have_content "DEF"
    end

    it "with no matches", js: true do
      page.find(".search-link").click
      fill_in "search", with: "foobar"
      page.find(".search-submit").click
      artists = page.all(".artist")
      expect(artists.size).to eq 0
    end
  end

  context "by letter" do
    before do
      FactoryBot.create(:artist, name: "ABC")
      visit artists_path
    end

    it "with matches" do
      click_on "A"

      albums = page.all(".artist")
      expect(albums.size).to eq 1
      expect(albums[0]).to have_content "ABC"
    end

    it "with no matches" do
      click_on "B"

      albums = page.all(".artist")
      expect(albums.size).to eq 0
    end
  end

  context "has a sidebar" do
    let(:artist)        { FactoryBot.create(:artist, name: "ABC") }
    let(:release_date1) { FactoryBot.create(:release_date, year: Date.current.year) }
    let(:release_date2) { FactoryBot.create(:release_date, year: Date.current.year - 1) }

    before do
      (1..3).each do |i|
        FactoryBot.create(:album, title: "Foo-#{i}", artist: artist,
                          release_date: release_date1)
      end
      FactoryBot.create(:album, title: "Foo-4", artist: artist,
                        release_date: release_date2)
      (5..7).each do |i|
        FactoryBot.create(:album, title: "Foo-#{i}", artist: artist,
                          release_date: release_date2)
      end

      visit artists_path
    end

    it "that lists newest albums" do
      expect(page).to     have_selector "div.new-albums h5", text: "Foo-3"
      expect(page).to     have_selector "div.new-albums h5", text: "Foo-2"
      expect(page).to     have_selector "div.new-albums h5", text: "Foo-1"
      expect(page).to     have_selector "div.new-albums h5", text: "Foo-6"
      expect(page).to     have_selector "div.new-albums h5", text: "Foo-5"
      expect(page).to     have_selector "div.new-albums h5", text: "Foo-7"
      expect(page).not_to have_selector "div.new-albums h5", text: "Foo-4"
    end
  end
end
