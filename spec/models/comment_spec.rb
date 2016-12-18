require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validity" do
    let(:comment) { FactoryGirl.build_stubbed(:comment_for_artist, body: "Comment") }

    it "when valid" do
      expect(comment).to be_valid
      expect(comment.body).to eq "Comment"
    end

    it "is invalid with blank comment" do
      comment.body = ""
      expect(comment).not_to be_valid
    end

    it "is valid with comment equal to 280 characters" do
      comment.body = "a" * 280
      expect(comment).to be_valid
    end

    it "is invalid with comment greater than 280 characters" do
      comment.body = "a" * 281
      expect(comment).not_to be_valid
    end
  end

  describe "updates timestamp" do
    let(:artist)  { FactoryGirl.create(:artist) }

    it "for commentable object when a comment is created" do
      timestamp = artist.updated_at
      FactoryGirl.create(:comment_for_artist, commentable: artist, body: "Comment") 
      expect(artist.updated_at).not_to eq timestamp
    end

    it "for commentable object when a comment is destroyed" do
      comment = FactoryGirl.create(:comment_for_artist, commentable: artist)
      timestamp = artist.updated_at
      comment.destroy!
      expect(artist.updated_at).not_to eq timestamp
    end
  end

  describe "#today" do
    it "returns comments only comments posted today" do
      FactoryGirl.create(:comment_for_artist, created_at: 1.day.ago, body: "1")
      FactoryGirl.create(:comment_for_artist, body: "2")
      expect(Comment.today.size).to eq 1
      expect(Comment.today.first.body).to eq "2"
    end
  end
end
