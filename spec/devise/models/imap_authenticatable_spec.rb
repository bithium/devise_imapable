# frozen_string_literal: true

require 'spec_helper'
require 'devise_setup'

RSpec.describe Devise::Models::ImapAuthenticatable do
  describe '.find_for_imap_authentication' do
    it 'is present on the User model class' do
      expect(User).to respond_to(:find_for_imap_authentication)
    end

    it 'calls the `.find_for_authentication` method by default' do
      allow(User).to receive(:find_for_authentication)

      User.find_for_imap_authentication({})

      expect(User).to have_received(:find_for_authentication)
    end
  end

  describe '#after_imap_authentication' do
    it 'is present on the User model' do
      expect(User.new).to respond_to(:after_imap_authentication)
    end
  end
end
