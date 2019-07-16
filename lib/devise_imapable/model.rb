# frozen_string_literal: true

require 'devise_imapable/strategy.rb'

module Devise
  module Models
    # :nodoc:
    module ImapAuthenticatable

      extend ActiveSupport::Concern

      def after_imap_authentication; end

      class_methods do
        def find_for_imap_authentication(conditions)
          find_for_authentication(conditions)
        end
      end

    end
  end
end
