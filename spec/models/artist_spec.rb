require 'rails_helper'

RSpec.describe Artist, type: :model do
  let!(:artist) { FactoryGirl.create(:artist) }

  it "has a name" do
    expect(artist.errors.messages.any?).to be_falsy
    expect(Artist.first.name).to eq("ABC")
  end

  it "must have a unique name" do
    artist = Artist.create(name: "ABC")
    expect(artist.errors.messages.any?).to be_truthy
    expect(artist.errors.messages[:name].first).to eq("has already been taken")
  end

  it "must have a case-insensitive unique name" do
    artist = Artist.create(name: "aBc")
    expect(artist.errors.messages.any?).to be_truthy
    expect(artist.errors.messages[:name].first).to eq("has already been taken")
  end
end
