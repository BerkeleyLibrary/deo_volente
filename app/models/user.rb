# Represents a user in our system
# A very stripped down version of CalNet's user schema.
class User
  include ActiveModel::Model

  DEOVOLENTE_USER_GROUP = 'cn=edu:berkeley:app:calnet-spa:group-spa-ucblibdataverse,ou=campus groups,dc=berkeley,dc=edu'.freeze

  class << self
    def from_omniauth(auth)
      # TODO: Add error handling
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
        dataverse_user: cal_groups.include?(DEOVOLENTE_USER_GROUP)
      }
    end
  end

  attr_accessor :uid
  attr_accessor :display_name
  attr_accessor :affiliations
  attr_accessor :email
  attr_accessor :dataverse_user

  alias dataverse_user? dataverse_user

  def authenticated?
    !uid.nil?
  end

end
