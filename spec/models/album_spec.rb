require "rails_helper"

RSpec.describe Album, type: :model do
  context ".artist_albums" do
    it "lists artist albums in reverse chronological order"
  end

  context "#title" do
    it "when valid"
    it "is invalid when blank"
  end

  context "#year" do
    it "when valid"
    it "is invalid when less than 1940"
    it "is invalid when greater than current year"
  end

  context "#tracks_list" do
    it "when valid"
    it "is invalid if duration is not provided"
    it "is invalid if any track is missing duration"
    it "is invalid if seconds duration is greater than 60"
  end

  context "#tracks_summary" do
    it "lists first six tracks"
    it "list all tracks if album has less than six tracks"
    it "emits 'No tracks' for empty album"
  end

  context "#total_duration" do
    it "computes album time length"
  end
end
