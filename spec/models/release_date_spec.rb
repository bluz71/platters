require "rails_helper"

RSpec.describe ReleaseDate, type: :model do
  let!(:release_date) { FactoryGirl.create(:release_date, year: 1999) }

  context "#year" do
    it "when valid" do
      expect(release_date).to be_valid
    end

    it "is unique" do
      release_date2 = FactoryGirl.build(:release_date, year: 1999)
      expect(release_date2).not_to be_valid
      expect(release_date2.errors.messages[:year].first).to eq "has already been taken"
    end

    it "is greater than 1940" do
      release_date2 = FactoryGirl.build(:release_date, year: 1885)
      expect(release_date2).not_to be_valid
      expect(release_date2.errors.messages[:year].first).to eq "must be greater than 1940"
    end
  end
end
