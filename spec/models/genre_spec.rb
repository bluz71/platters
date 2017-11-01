require "rails_helper"

RSpec.describe Genre, type: :model do
  let!(:genre) { FactoryBot.create(:genre, name: "Rock") }

  describe "#name" do
    it "when valid" do
      expect(genre).to be_valid
    end

    it "is unique" do
      genre2 = FactoryBot.build(:genre, name: "Rock")
      expect(genre2).not_to be_valid
      expect(genre2.errors.messages[:name].first).to eq "has already been taken"
    end

    it "is case-insensitively unique" do
      genre2 = FactoryBot.build(:genre, name: "rOcK")
      expect(genre2).not_to be_valid
      expect(genre2.errors.messages[:name].first).to eq "has already been taken"
    end
  end
end
