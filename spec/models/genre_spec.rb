require "rails_helper"

RSpec.describe Genre, type: :model do
  let!(:genre) { FactoryGirl.create(:genre) }

  it "with valid name" do
    expect(genre.errors.messages.any?).to be_falsy
    expect(Genre.first.name).to eq "Rock"
  end

  it "must have a unique name" do
    genre2 = Genre.create(name: "Rock")
    expect(genre2.errors.messages.any?).to be_truthy
    expect(genre2.errors.messages[:name].first).to eq "has already been taken"
  end

  it "must have a unique name" do
    genre2 = Genre.create(name: "rOcK")
    expect(genre2.errors.messages.any?).to be_truthy
    expect(genre2.errors.messages[:name].first).to eq "has already been taken"
  end
end
