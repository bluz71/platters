require "rails_helper"

RSpec.describe "Showing comments", type: :system do
  let(:artist) { FactoryBot.create(:artist) }

  context "for artists" do
    before do
      FactoryBot.create(
        :comment_for_artist, commentable: artist, body: "First comment"
      )
      FactoryBot.create(
        :comment_for_artist, commentable: artist, body: "Second comment"
      )
    end

    it "with few comments" do
      visit artist_path(artist)

      expect(page).to have_content "First comment"
      expect(page).to have_content "Second comment"
    end

    it "with many comments will display first twenty five newest " \
             "comments by default" do
      23.times do
        FactoryBot.create(
          :comment_for_artist, commentable: artist, body: "A comment"
        )
      end
      FactoryBot.create(
        :comment_for_artist, commentable: artist, body: "Newest comment"
      )

      visit artist_path(artist)
      expect(page).to have_content "Newest comment"
      expect(page).not_to have_content "First comment"
    end

    it "with many comments when scrolled to the end of the page will " \
             "retrieve the next twenty five comments", js: true do
      23.times do
        FactoryBot.create(
          :comment_for_artist, commentable: artist, body: "A comment"
        )
      end
      FactoryBot.create(
        :comment_for_artist, commentable: artist, body: "Newest comment"
      )

      visit artist_path(artist)

      Capybara.using_wait_time 5 do
        # Scroll to the end of the page.
        page.execute_script("window.scrollTo(0,100000)")
        wait_for_js

        expect(page).to have_content "Newest comment"
        expect(page).to have_content "First comment"
      end
    end
  end

  context "for albums and users" do
    let(:user) { FactoryBot.create(:user) }
    let(:release_date) { FactoryBot.create(:release_date) }
    let(:album) do
      FactoryBot.create(:album, artist: artist, release_date: release_date)
    end

    before do
      FactoryBot.create(
        :comment_for_artist, commentable: album, user: user,
        body: "First comment"
      )
      24.times do
        FactoryBot.create(
          :comment_for_artist, commentable: album, user: user, body: "A comment"
        )
      end
      FactoryBot.create(
        :comment_for_artist, commentable: album, user: user,
        body: "Newest comment"
      )
    end

    it "with many comments when scrolled to the end of the album page " \
             "will retrieve the next twenty five comments", js: true do
      visit artist_album_path(artist, album)
      expect(page).to have_content "Newest comment"
      expect(page).not_to have_content "First comment"

      # Scroll to the end of the page.
      page.execute_script("window.scrollTo(0,100000)")

      expect(page).to have_content "Newest comment"
      expect(page).to have_content "First comment"
    end

    it "with many comments when scrolled to the end of the user page " \
             "will retrieve the next twenty five comments", js: true do
      visit user_comments_path(user)
      expect(page).to have_content "Newest comment"
      expect(page).not_to have_content "First comment"

      # Scroll to the end of the page.
      page.execute_script("window.scrollTo(0,100000)")

      expect(page).to have_content "Newest comment"
      expect(page).to have_content "First comment"
    end

    it "will display an error message for an invalid user path" do
      visit user_comments_path("foo")

      expect(current_path).to eq root_path
      expect(page).to have_content "User foo does not exist"
    end
  end
end
