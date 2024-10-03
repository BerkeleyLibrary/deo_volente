# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:auth) do
    {
      'provider' => 'calnet',
      'extra' => {
        'berkeleyEduAffiliations' => 'expected affiliation',
        'displayName' => 'expected display name',
        'berkeleyEduAlternateID' => 'expected email',
        'uid' => 'expected UID'
      }
    }
  end

  it 'populates the users affiliations' do
    user = described_class.from_omniauth(auth)
    expect(user.affiliations).to eq('expected affiliation')
  end

  it 'populates the users display name' do
    user = described_class.from_omniauth(auth)
    expect(user.display_name).to eq('expected display name')
  end

  it 'populates the users email' do
    user = described_class.from_omniauth(auth)
    expect(user.email).to eq('expected email')
  end

  it 'populates the users UID' do
    user = described_class.from_omniauth(auth)
    expect(user.uid).to eq('expected UID')
  end

  it 'sets dataverse_user to true if user is a member of deo volente' do
    auth['extra']['berkeleyEduIsMemberOf'] = described_class::DEOVOLENTE_GROUP
    user = described_class.from_omniauth(auth)
    expect(user.dataverse_user).to be(true)
  end

  it 'sets dataverse_user to false if user is not a member of deo volente' do
    auth['extra']['berkeleyEduIsMemberOf'] = ''
    user = described_class.from_omniauth(auth)
    expect(user.dataverse_user).to be(false)
  end

  describe '#authenticated?' do
    it 'returns true if user has an ID' do
      user = described_class.new(uid: '12345')
      expect(user.authenticated?).to be(true)
    end

    it 'returns false if user ID is nil' do
      user = described_class.new(uid: nil)
      expect(user.authenticated?).to be(false)
    end
  end
end
