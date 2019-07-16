# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Devise do
  describe '.imap_server' do
    it 'is present' do
      expect(described_class).to respond_to(:imap_server)
    end

    it 'has a default value' do
      expect(described_class.imap_server).to eq('mail.example.com')
    end
  end

  describe '.imap_email_domain' do
    it 'is present' do
      expect(described_class).to respond_to(:imap_email_domain)
    end

    it 'has a default value' do
      expect(described_class.imap_email_domain).to eq('example.com')
    end
  end

  describe '.imap_email_attribute' do
    it 'is present' do
      expect(described_class).to respond_to(:imap_email_attribute)
    end

    it 'has a default value' do
      expect(described_class.imap_email_attribute).to eq(:email)
    end
  end
end
