# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Devise::Imap::Adapter do
  describe '.valid_credentials?' do
    let(:username)  { Faker::Internet.safe_email }
    let(:password)  { Faker::Internet.password }
    let(:imap_conn) { instance_double(Net::IMAP) }
    let(:domain)    { username.split('@').last }

    before do
      allow(Net::IMAP).to receive(:new).and_return(imap_conn)
      allow(imap_conn).to receive(:disconnect)

      ::Devise.imap_server       = domain
      ::Devise.imap_email_domain = domain
    end

    context 'when the IMAP server is not set' do
      it 'returns false' do
        ::Devise.imap_server = nil
        expect(described_class.valid_credentials?(username, password)).to eq(false)
      end
    end

    context 'when the IMAP domain is not set' do
      before do
        allow(imap_conn).to receive(:authenticate)
      end

      it 'allows emails for any domain' do
        ::Devise.imap_email_domain = nil

        described_class.valid_credentials?(username, password)

        expect(imap_conn).to have_received(:authenticate)
      end
    end

    context 'when the IMAP domain is set' do
      before do
        allow(imap_conn).to receive(:authenticate)
      end

      it 'allows emails for the domain' do
        ::Devise.imap_email_domain = domain

        described_class.valid_credentials?(username, password)

        expect(imap_conn).to have_received(:authenticate)
      end

      it 'does not allow emails from other domains', aggregate_failures: true do
        ::Devise.imap_email_domain = domain

        username = Faker::Internet.free_email
        expect(described_class.valid_credentials?(username, password)).to eq(false)

        expect(imap_conn).not_to have_received(:authenticate)
      end
    end

    context 'when the credentials are valid' do
      before do
        allow(imap_conn).to receive(:authenticate)
      end

      it 'returns true' do
        expect(described_class.valid_credentials?(username, password)).to eq(true)
      end

      it 'closes the IMAP connection' do
        described_class.valid_credentials?(username, password)
        expect(imap_conn).to have_received(:disconnect)
      end
    end

    context 'when the username is not present' do
      it 'returns false' do
        expect(described_class.valid_credentials?(nil, password)).to eq(false)
      end
    end

    context 'when the password is not present' do
      it 'returns false' do
        expect(described_class.valid_credentials?(username, nil)).to eq(false)
      end
    end

    # rubocop:disable RSpec/MessageChain
    context 'when the credentials are invalid' do
      before do
        res = double
        allow(res).to receive_message_chain(:data, :text) { 'NOK' }

        allow(imap_conn).to receive(:authenticate) do
          raise Net::IMAP::NoResponseError, res
        end
      end

      it 'returns false' do
        expect(described_class.valid_credentials?(username, password)).to eq(false)
      end

      it 'closes the IMAP connection' do
        described_class.valid_credentials?(username, password)

        expect(imap_conn).to have_received(:disconnect)
      end
    end
    # rubocop:enable RSpec/MessageChain
  end
end
