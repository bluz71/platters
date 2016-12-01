require "rails_helper"

RSpec.feature "Removing comments" do
  context "from artists" do
    scenario "is not possible for anonymous users"
    scenario "is disallowed if you did not post the comment"
    scenario "will succeed if you posted the comment"
    scenario "by an administrator has no restrictions"
    scenario "will update comment count"
    scenario "updates the timestamp for the artist"
    scenario "display 'No comments' when comment count reaches zero"
  end

  context "from albums" do
    scenario "is not possible for anonymous users"
    scenario "is disallowed if you did not post the comment"
    scenario "will succeed if you posted the comment"
    scenario "by an administrator has no restrictions"
    scenario "will update comment count"
    scenario "updates the timestamp for the album"
    scenario "display 'No comments' when comment count reaches zero"
  end
end
