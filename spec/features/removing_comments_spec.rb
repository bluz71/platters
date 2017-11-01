require "rails_helper"

RSpec.feature "Removing comments" do
  let(:user)         { FactoryBot.create(:user) }
  let(:admin)        { FactoryBot.create(:admin) }
  let(:artist)       { FactoryBot.create(:artist) }
  let(:release_date) { FactoryBot.create(:release_date) }
  let(:album) do
    FactoryBot.create(:album, artist: artist, release_date: release_date)
  end

  context "from artists" do
    let!(:my_comment) do
      FactoryBot.create(:comment_for_artist, commentable: artist,
                        user: user, body: "My artist comment")
    end

    let!(:not_my_comment) do
      FactoryBot.create(:comment_for_artist, commentable: artist,
                        body: "Not my artist comment")
    end

    scenario "is not possible for anonymous users" do
      visit artist_path(artist)
      expect(page).not_to have_css "a[data-confirm]"
    end

    scenario "is disallowed if you did not post the comment" do
      visit artist_path(artist, as: user.id)
      comments = page.all(".comment")
      expect(comments.count).to eq 2
      expect(comments[0]).not_to have_css "a[data-confirm]"
      expect(comments[1]).to     have_css "a[data-confirm]"
    end

    scenario "will succeed if you posted the comment", js: true do
      visit artist_path(artist, as: user.id)
      accept_alert do
        page.find(".destroy-comment").click
      end
      expect(page).not_to have_content "My artist comment"
    end

    scenario "by an administrator has no restrictions", js: true do
      visit artist_path(artist, as: admin.id)
      accept_alert do
        page.first(".destroy-comment").click
      end
      expect(page).not_to have_content "Not my artist comment"
    end

    scenario "will update comment count", js: true do
      visit artist_path(artist, as: user.id)
      expect(page).to have_content "2 Comments"

      accept_alert do
        page.find(".destroy-comment").click
      end
      expect(page).to have_content "1 Comment"
    end

    scenario "display 'No comments' when comment count reaches zero", js: true do
      Comment.second.destroy
      visit artist_path(artist, as: user.id)
      accept_alert do
        page.find(".destroy-comment").click
      end
      expect(page).to have_content "0 Comments"
      expect(page).to have_content "No comments have been posted for this artist"
    end
  end

  context "from albums" do
    let!(:my_comment) do
      FactoryBot.create(:comment_for_album, commentable: album,
                        user: user, body: "My album Comment")
    end
    let!(:not_my_comment) do
      FactoryBot.create(:comment_for_album, commentable: album,
                        body: "Not my album Comment")
    end

    scenario "is not possible for anonymous users" do
      visit artist_album_path(artist, album)
      expect(page).not_to have_css "a[data-confirm]"
    end

    scenario "is disallowed if you did not post the comment" do
      visit artist_album_path(artist, album, as: user.id)
      comments = page.all(".comment")
      expect(comments.count).to eq 2
      expect(comments[0]).not_to have_css "a[data-confirm]"
      expect(comments[1]).to     have_css "a[data-confirm]"
    end

    scenario "will succeed if you posted the comment", js: true do
      visit artist_album_path(artist, album, as: user.id)
      accept_alert do
        page.find(".destroy-comment").click
      end
      expect(page).not_to have_content "My album comment"
    end

    scenario "by an administrator has no restrictions", js: true do
      visit artist_album_path(artist, album, as: admin.id)
      accept_alert do
        page.first(".destroy-comment").click
      end
      expect(page).not_to have_content "Not my album comment"
    end

    scenario "will update comment count", js: true do
      visit artist_album_path(artist, album, as: user.id)
      expect(page).to have_content "2 Comments"

      accept_alert do
        page.find(".destroy-comment").click
      end
      expect(page).to have_content "1 Comment"
    end

    scenario "display 'No comments' when comment count reaches zero", js: true do
      Comment.second.destroy
      visit artist_album_path(artist, album, as: user.id)
      accept_alert do
        page.find(".destroy-comment").click
      end
      expect(page).to have_content "0 Comments"
      expect(page).to have_content "No comments have been posted for this album"
    end
  end
end
