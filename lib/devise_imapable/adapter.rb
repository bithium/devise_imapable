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

require 'net/imap'

module Devise
  module Imap
    # Simple adapter to authenticate using an IMAP server
    module Adapter

      def self.valid_credentials?(username, password)
        return false unless username.present? && password.present?
        return false unless ::Devise.imap_server && valid_domain?(username)

        imap = Net::IMAP.new(::Devise.imap_server)
        imap.authenticate('cram-md5', username, password)

        true
      rescue Net::IMAP::ResponseError
        false
      ensure
        imap&.disconnect
      end

      def self.valid_domain?(username)
        return true unless ::Devise.imap_email_domain

        username.ends_with?(::Devise.imap_email_domain)
      end

    end
  end
end
