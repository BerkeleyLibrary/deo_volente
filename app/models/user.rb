#  frozen_string_literal: true

# Represents a user in our system
# A very stripped down version of CalNet's user schema.
class User
  include ActiveModel::Model

  DEOVOLENTE_GROUP = 'cn=edu:berkeley:org:libr:dataverse:deovolente,ou=campus groups,dc=berkeley,dc=edu'

  class << self
    def from_omniauth(auth)
      new(**auth_params_from(auth))
    end

    private

    def auth_params_from(auth)
      auth_extra = auth['extra']
      cal_groups = auth_extra['berkeleyEduIsMemberOf'] || []

      {
        affiliations: auth_extra['berkeleyEduAffiliations'],
        display_name: auth_extra['displayName'],
        email: auth_extra['berkeleyEduAlternateID'],
        uid: auth_extra['uid'] || auth['uid'],
        dataverse_user: cal_groups.include?(DEOVOLENTE_GROUP)
      }
    end
  end

  attr_accessor :uid, :display_name, :affiliations, :email, :dataverse_user

  alias dataverse_user? dataverse_user

  def authenticated?
    !uid.nil?
  end
end
