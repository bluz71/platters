require "rails_helper"

RSpec.feature "Showing comments" do
  let(:artist) { FactoryGirl.create(:artist) }

  context "for artists" do
    before do
      FactoryGirl.create(:comment_for_artist, commentable: artist,
                         body: "First comment")
      FactoryGirl.create(:comment_for_artist, commentable: artist,
                         body: "Second comment")
    end

    scenario "with few comments" do
      visit artist_path(artist)

      expect(page).to have_content "First comment"
      expect(page).to have_content "Second comment"
    end

    scenario "with many comments will display first twenty five newest comments by default" do
      23.times do
        FactoryGirl.create(:comment_for_artist, commentable: artist,
                           body: "A comment")
      end
      FactoryGirl.create(:comment_for_artist, commentable: artist,
                         body: "Newest comment")

      visit artist_path(artist)
      expect(page).to     have_content "Newest comment"
      expect(page).not_to have_content "First comment"
    end

    scenario "with many comments when scrolled to the end of the page will retrieve the next twenty five comments", js:true do
      23.times do
        FactoryGirl.create(:comment_for_artist, commentable: artist,
                           body: "A comment")
      end
      FactoryGirl.create(:comment_for_artist, commentable: artist,
                         body: "Newest comment")

      visit artist_path(artist)

      # Scroll to the end of the page.
      page.execute_script('window.scrollTo(0,100000)')

      expect(page).to have_content "Newest comment"
      expect(page).to have_content "First comment"
    end
  end

  context "for albums and users" do
    let(:release_date) { FactoryGirl.create(:release_date) }
    let(:album)        { FactoryGirl.create(:album,
                                            artist: artist,
                                            release_date: release_date) }
    let(:user)         { FactoryGirl.create(:user) }

    before do
      FactoryGirl.create(:comment_for_artist, commentable: album, user: user,
                         body: "First comment")
      24.times do
        FactoryGirl.create(:comment_for_artist, commentable: album, user: user,
                           body: "A comment")
      end
      FactoryGirl.create(:comment_for_artist, commentable: album, user: user,
                         body: "Newest comment")

    end

    scenario "with many comments when scrolled to the end of the album page will retrieve the next twenty five comments", js:true do
      visit artist_album_path(artist, album)
      expect(page).to     have_content "Newest comment"
      expect(page).not_to have_content "First comment"

      # Scroll to the end of the page.
      page.execute_script('window.scrollTo(0,100000)')

      expect(page).to have_content "Newest comment"
      expect(page).to have_content "First comment"
    end

    scenario "with many comments when scrolled to the end of the user page will retrieve the next twenty five comments", js:true do
      visit user_comments_path(user)
      expect(page).to     have_content "Newest comment"
      expect(page).not_to have_content "First comment"

      # Scroll to the end of the page.
      page.execute_script('window.scrollTo(0,100000)')

      expect(page).to have_content "Newest comment"
      expect(page).to have_content "First comment"
    end
  end
end
