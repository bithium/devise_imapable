# frozen_string_literal: true

require 'devise'
require 'devise_imapable/version'
require 'devise_imapable/strategy'

# rubocop:disable Style/ClassVars
# :nodoc:
module Devise

  # IMAP server address for authentication.
  mattr_accessor :imap_server
  @@imap_server = 'mail.example.com'

  # Email domain
  mattr_accessor :imap_email_domain
  @@imap_email_domain = 'example.com'

  # User model email attribute
  mattr_accessor :imap_email_attribute
  @@imap_email_attribute = :email

end
# rubocop:enable Style/ClassVars

# Add +:imap_authenticable+ strategy to defaults.
Devise.add_module(:imap_authenticatable,
                  strategy:   true,
                  controller: :sessions,
                  model:      'devise_imapable/model')
