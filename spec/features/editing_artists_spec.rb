require "rails_helper"

RSpec.feature "Editing artists" do
  let!(:artist1) { FactoryGirl.create(:artist) }
  let!(:artist2) { FactoryGirl.create(:artist, name: "XYZ") }

  before do
    visit artist_path(artist1)
    click_on "Edit"
  end

  scenario "with new name" do
    fill_in "Name", with: "CBA"
    click_on "Submit"

    expect(current_path).to eq artist_path(artist1)
    expect(page).to have_content "CBA has been updated"
    expect(page).to have_title "CBA"
    expect(page).to have_selector "div#artist h1", text: "CBA"
  end

  scenario "fails with blank name" do
    fill_in "Name", with: ""
    click_on "Submit"

    expect(page).to have_content "Artist could not be updated"
    expect(page).to have_content "Name can't be blank"
  end

  scenario "fails when using an existing artist name" do
    fill_in "Name", with: "XYZ"
    click_on "Submit"

    expect(page).to have_content "Artist could not be updated"
    expect(page).to have_content "Name has already been taken"
  end
end
