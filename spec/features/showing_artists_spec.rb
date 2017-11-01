require "rails_helper"

RSpec.feature "Showing artists" do
  scenario "details will include description, Wikipedia link and web-site link" do
    artist = FactoryBot.create(:artist,
                               name: "ABC",
                               description: "ABC is the artist.",
                               wikipedia: "ABC_Artist",
                               website: "http://www.abc_artist.com")
    visit artist_path(artist)

    expect(page).to have_title "ABC"
    expect(page).to have_selector "div#artist h1", text: "ABC"
    expect(page).to have_selector "div#artist .description", text: "ABC is the artist."
    expect(page).to have_link("Wikipedia",
                              href: "https://www.wikipedia.org/wiki/ABC_Artist")
    expect(page).to have_link "abc_artist.com", href: "http://www.abc_artist.com"
  end

  scenario "will display an error message for an invalid artist path" do
    visit artist_path("foo")

    expect(current_path).to eq artists_path
    expect(page).to have_content "The artist 'foo' does not exist"
  end
end
