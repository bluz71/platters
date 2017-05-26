require "rails_helper"

RSpec.feature "Adding comments" do
  let(:user)         { FactoryGirl.create(:user) }
  let(:artist)       { FactoryGirl.create(:artist) }
  let(:release_date) { FactoryGirl.create(:release_date) }
  let(:album) do
    FactoryGirl.create(:album, artist: artist, release_date: release_date)
  end

  context "to artists" do
    scenario "is not possible for anonymous users" do
      visit artist_path(artist)
      expect(page).not_to have_css "textarea[id='comment_body']"
    end

    scenario "when posted with valid text", js: true do
      visit artist_path(artist, as: user.id)
      expect(page).to have_css "textarea[id='comment_body']"

      fill_in "comment_body", with: "An artist comment"
      click_on "Post it"
      expect(page).to have_selector "div.comment p", text: "An artist comment"
    end

    scenario "updates comment counter upon each key stroke", js: true do
      visit artist_path(artist, as: user.id)
      expect(page).to have_content "280"
      fill_in "comment_body", with: "123456"
      expect(page).to have_content "274"
    end

    scenario "will display the local time of the posted comment", js: true do
      comment_date = if Time.current < Time.parse("Jan 8")
                       "Dec 1"
                     else
                       "Jan 1"
                     end
      travel_to Time.parse(comment_date)
      visit artist_path(artist, as: user.id)
      fill_in "comment_body", with: "Testing dates"
      click_on "Post it"
      wait_for_js
      travel_back
      expect(page).to have_content "on #{comment_date}"
    end

    scenario "only stores newlines for comments containing returns", js: true do
      visit artist_path(artist, as: user.id)
      fill_in "comment_body", with: <<~COMMENT
                                       1
                                       2
                                       3
                                    COMMENT
      click_on "Post it"
      wait_for_js
      expect(Comment.last.body).to eq "1\n2\n3\n"
    end

    scenario "when posted will update comment count", js: true do
      visit artist_path(artist, as: user.id)
      expect(page).to have_content "0 Comments"

      fill_in "comment_body", with: "A comment"
      click_on "Post it"
      expect(page).to have_content "1 Comment"

      fill_in "comment_body", with: "A 2nd comment"
      click_on "Post it"
      expect(page).to have_content "2 Comments"
    end

    scenario "when posted with text containing links", js: true do
      visit artist_path(artist, as: user.id)
      fill_in "comment_body", with: <<~COMMENT
                                       A link to Google:
                                       https://www.google.com
                                    COMMENT
      click_on "Post it"
      expect(page).to have_link "https://www.google.com", href: "https://www.google.com"
    end

    scenario "is not possible with a blank comment", js: true do
      visit artist_path(artist, as: user.id)
      expect(page).to have_button("Post it", disabled: true)
    end

    scenario "is not possible with a comment longer than 280 characters", js: true do
      visit artist_path(artist, as: user.id)

      fill_in "comment_body", with: "a" * 280
      expect(page).to have_button("Post it", disabled: false)

      fill_in "comment_body", with: "a" * 281
      expect(page).to have_button("Post it", disabled: true)
    end

    scenario "is not possible when a user has posted 100 or more comments "\
             "today", js: true do
      travel_to Time.parse("12AM") do
        99.times { artist.comments.create(user: user, body: "Comment") }

        visit artist_path(artist, as: user.id)
        fill_in "comment_body", with: "100th comment"
        click_on "Post it"
        expect(page).to have_selector "div.comment p", text: "100th comment"

        fill_in "comment_body", with: "Another comment"
        click_on "Post it"
        fill_in "comment_body", with: "Another comment"
        click_on "Post it"
        fill_in "comment_body", with: "Another comment"
        click_on "Post it"
        expect(page).not_to have_selector "div.comment p", text: "Another comment"
        expect(page).to have_content "User limit of 100 comments per-day "\
                                     "has been exceeded"
      end
    end
  end

  context "to albums" do
    scenario "is not possible for anonymous users" do
      visit artist_album_path(artist, album)
      expect(page).not_to have_css "textarea[id='comment_body']"
    end

    scenario "when posted with valid text", js: true do
      visit artist_album_path(artist, album, as: user.id)
      expect(page).to have_css "textarea[id='comment_body']"

      fill_in "comment_body", with: "An album comment"
      click_on "Post it"
      expect(page).to have_selector "div.comment p", text: "An album comment"
    end

    scenario "updates comment counter upon each key stroke", js: true do
      visit artist_album_path(artist, album, as: user.id)
      expect(page).to have_content "280"
      fill_in "comment_body", with: "123456"
      expect(page).to have_content "274"
    end

    scenario "will display the local time of the posted comment", js: true do
      comment_date = if Time.current < Time.parse("Jan 8")
                       "Dec 1"
                     else
                       "Jan 1"
                     end
      travel_to Time.parse(comment_date)
      visit artist_album_path(artist, album, as: user.id)
      fill_in "comment_body", with: "Testing dates"
      click_on "Post it"
      wait_for_js
      travel_back
      expect(page).to have_content "on #{comment_date}"
    end

    scenario "when posted will update comment count", js: true do
      visit artist_album_path(artist, album, as: user.id)
      expect(page).to have_content "0 Comments"

      fill_in "comment_body", with: "A comment"
      click_on "Post it"
      expect(page).to have_content "1 Comment"

      fill_in "comment_body", with: "A 2nd comment"
      click_on "Post it"
      expect(page).to have_content "2 Comments"
    end
  end
end
