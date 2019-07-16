# frozen_string_literal: true

require 'devise_imapable/adapter'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    # Strategy for signing in a user based on his email and password using imap.
    # Redirects to sign_in page if it's not authenticated
    class ImapAutheticable < Authenticatable

      # Authenticate a user based on email and password params, returning to warden
      # success and the authenticated user if everything is okay. Otherwise redirect
      # to sign in page.
      #
      # rubocop:disable Style/SignalException
      def authenticate!
        resource = mapping.to.find_for_imap_authentication(authentication_hash)

        return fail!(:invalid) unless resource

        email = resource.send(::Devise.imap_email_attribute)

        return fail(:invalid) unless Devise::Imap::Adapter.valid_credentials?(email, password)

        remember_me(resource)
        resource.after_imap_authentication
        success!(resource)
      end
      # rubocop:enable Style/SignalException

    end
  end
end

Warden::Strategies.add(:imap_authenticatable, Devise::Strategies::ImapAutheticable)
