#
# Copyright (C) 2019 Bithium S.A.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# frozen_string_literal: true

require 'devise/imap/adapter'
require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    # Strategy for signing in a user based on his email and password using imap.
    # Redirects to sign_in page if it's not authenticated
    class ImapAuthenticatable < Authenticatable


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

Warden::Strategies.add(:imap_authenticatable, Devise::Strategies::ImapAuthenticatable)
