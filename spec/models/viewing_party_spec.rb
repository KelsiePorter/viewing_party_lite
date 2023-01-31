require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  describe 'relations' do
    it { should belong_to(:host) }
    it { should have_many :viewing_party_users }
    it { should have_many(:users).through(:viewing_party_users) }
  end
end
