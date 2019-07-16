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
