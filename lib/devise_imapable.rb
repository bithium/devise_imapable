# frozen_string_literal: true

require 'devise'
require 'devise_imapable/version'

# :nodoc:
module Devise

  # IMAP server address for authentication.
  mattr_accessor :imap_server

  # Email suffix
  mattr_accessor :imap_email_domain

end
