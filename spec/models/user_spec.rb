# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  # rubocop:disable RSpec/ExampleLength
  it 'populates a User object' do
    # rubocop:disable Layout/LineLength
    dataverse_user_group = 'cn=edu:berkeley:app:calnet-spa:group-spa-ucblibdataverse,ou=campus groups,dc=berkeley,dc=edu'
    # rubocop:enable Layout/LineLength

    auth = {
      'provider' => 'calnet',
      'extra' => {
        'berkeleyEduAffiliations' => 'expected affiliation',
        'displayName' => 'expected display name',
        'berkeleyEduAlternateID' => 'expected email',
        'uid' => 'expected UID'
      }
    }

    [true, false].each do |dataverse_user|
      auth['extra']['berkeleyEduIsMemberOf'] = dataverse_user ? dataverse_user_group : ''
      user = described_class.from_omniauth(auth)
      expect(user).to have_attributes(
        affiliations: 'expected affiliation',
        display_name: 'expected display name',
        email: 'expected email',
        uid: 'expected UID'
      )
    end
  end
  # rubocop:enable RSpec/ExampleLength

  it 'returns true if user has an ID' do
    user = described_class.new(uid: '12345')
    expect(user.authenticated?).to be(true)
  end

  it 'returns false if user ID is nil' do
    user = described_class.new(uid: nil)
    expect(user.authenticated?).to be(false)
  end
end
