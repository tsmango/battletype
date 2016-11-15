require "rails_helper"

RSpec.describe Player, type: :model do
  let(:game) { Game.new }
  subject(:player) { Player.new game: game }
  
  describe "#plays_in?" do
    it "is true if a player is part of the given game", :aggregate_failures do
      expect(player.plays_in?(game)).to be_truthy
      expect(player.plays_in?(Game.new)).to be_falsy
    end
  end
end
