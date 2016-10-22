require "rails_helper"

RSpec.describe "Attacks", type: :request do
  let(:game)            { Game.create!(name: 'Starship Battle') }
  let(:player)          { game.players.create!(nickname: "Rico") }

  before :each do
    allow_any_instance_of(ApplicationController).to receive(:current_player).and_return(player)
  end

  describe "POST create" do
    context 'when no word is provided' do
      it 'returns 422 HTTP status' do
        post "/attacks"
        expect(response).to have_http_status(422)
      end
    end

    context "when provided word is an English word" do
      it "returns 200 HTTP status" do
        allow_words("curry")
        post "/attacks", params: { word: 'curry' }
        expect(response).to have_http_status(200)
      end
    end

    context 'when provided word has already been played' do
      before :each do
        game.words.create!(value: 'duplicate')
      end

      it 'returns 200 HTTP status' do
        post "/attacks", params: { word: 'duplicate' }
        expect(response).to have_http_status(200)
      end
    end

    context 'when provided word has already been played with a different case' do
      before :each do
        game.words.create!(value: 'BattleType')
      end

      it 'returns 422 HTTP status' do
        post "/attacks", params: { word: 'battletype' }
        expect(response).to have_http_status(200)
      end
      
      it 'broadcasts an error message' do
        allow(ActionCable.server).to receive(:broadcast)
        post "/attacks", params: { word: 'battletype' }
        expect(ActionCable.server).to have_received(:broadcast).with(anything, player_id: player.id, invalid_word: 'battletype', error_codes: ["unique_case_insensitive_word", "english_word"])
      end
    end

    # NEXT:
    # - mot du dico anglais
    # - mot pas du dico anglais
    # - meme mot pluriel
    # - meme mot singulier
  end
end
