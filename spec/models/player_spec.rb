require 'rails_helper'

describe Player, type: :model do
  it { is_expected.to belong_to(:game) }
  it { is_expected.to have_many(:ships) }
end
