# frozen_string_literal: true

require 'rails_helper'

module CalnetHelper
  def login_as_patron(patron_id)
    mock_login(patron_id)
  end

  def mock_login(uid)
    auth_hash = auth_hash_for(uid)
    mock_omniauth_login(auth_hash)
  end

  def auth_hash_for(uid)
    calnet_hml_file = "spec/data/calnet/#{uid}.yml"
    raise IOError, "File not found: #{calnet_hml_file}" unless File.exist?(calnet_hml_file)

    YAML.load_file(calnet_hml_file)
  end

  def mock_omniauth_login(auth_hash)
    last_signed_in_user = nil

    # We want the actual user object from the session, but system specs don't provide
    # access to it, so we intercept it at sign-in

    # TODO: figure out how to do this w/o using allow_any_instance_of!
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(SessionsController).to receive(:sign_in).and_wrap_original do |m, *args|
      last_signed_in_user = args[0]
      m.call(*args)
    end
    # rubocop:enable RSpec/AnyInstance

    log_in_with_omniauth(auth_hash)

    last_signed_in_user
  end

  def do_get(path)
    return visit(path) if respond_to?(:visit)

    get(path)
  end

  private

  def log_in_with_omniauth(auth_hash)
    OmniAuth.config.mock_auth[:calnet] = auth_hash
    do_get login_path

    Rails.application.env_config['omniauth.auth'] = auth_hash
    do_get omniauth_callback_path(:calnet)
  end
end

RSpec.configure do |config|
  config.include(CalnetHelper)
end
