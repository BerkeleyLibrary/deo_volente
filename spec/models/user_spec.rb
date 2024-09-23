require 'rails_helper'

describe User do
  describe :auth_params_from do
    it 'populates a User object' do
      dataverse_user_group = 'cn=edu:berkeley:app:calnet-spa:group-spa-ucblibdataverse,ou=campus groups,dc=berkeley,dc=edu'
      auth = {
        'provider' => 'calnet',
        'extra' => {
          'berkeleyEduAffiliations' => 'expected affiliation',
          'displayName' => 'expected display name',
          'berkeleyEduAlternateID' => 'expected email',
          'uid' => 'expected UID',
          'berkeleyEduIsMemberOf' => dataverse_user_group
        }
      }

      [true, false].each do |dataverse_user|
        auth['extra']['berkeleyEduIsMemberOf'] = dataverse_user ? dataverse_user_group : ''
        user = User.from_omniauth(auth)
        expect(user.affiliations).to eq('expected affiliation')
        expect(user.display_name).to eq('expected display name')
        expect(user.email).to eq('expected email')
        expect(user.uid).to eq('expected UID')
        expect(user.dataverse_user).to eq(dataverse_user)
      end
    end
  end


  describe :authenticated? do
    it 'returns true if user has an ID' do
      user = User.new(uid: '12345')
      expect(user.authenticated?).to eq(true)
    end

    it 'returns false if user ID is nil' do
      user = User.new(uid: nil)
      expect(user.authenticated?).to eq(false)
    end
  end
end