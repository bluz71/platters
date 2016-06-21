require "rails_helper"

RSpec.describe ReleaseDate, type: :model do
  let!(:release_date) { FactoryGirl.create(:release_date) }

  it "with valid year" do
    expect(release_date.errors.messages.any?).to be_falsy
    expect(ReleaseDate.first.year).to eq 1985
  end

  it "must have a unique year" do
    release_date2 = ReleaseDate.create(year: 1985)
    expect(release_date2.errors.messages.any?).to be_truthy
    expect(release_date2.errors.messages[:year].first).to eq "has already been taken"
  end

  it "must be a year greater than 1940" do
    release_date2 = ReleaseDate.create(year: 1885)
    expect(release_date2.errors.messages.any?).to be_truthy
    expect(release_date2.errors.messages[:year].first).to eq "must be greater than 1940"
  end
end
