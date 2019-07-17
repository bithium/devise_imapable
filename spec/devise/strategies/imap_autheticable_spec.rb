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

require 'spec_helper'
require 'devise_setup'

RSpec.describe Devise::Strategies::ImapAuthenticatable do
  subject(:strategy) { described_class.new(args, :user) }

  let!(:email)    { Faker::Internet.safe_email }
  let!(:password) { Faker::Internet.password }
  let!(:params)   { { 'user[email]' => email, 'user[password]' => password } }
  let!(:env)      { { 'devise.allow_params_authentication' => true } }
  let!(:args)     { env_with_params('/users/sign_in', params, env) }

  let(:user)      { User.new(email: email) }

  describe '#valid?' do
    context 'when `Devise.imap_email_domain` is not set' do
      it 'returns false' do
        Devise.imap_email_domain = nil
        expect(strategy.valid?).to eq(false)
      end
    end

    context 'when `Devise.imap_email_domain` is set' do
      it 'returns true if the attribute matches' do
        Devise.imap_email_domain = email.split('@').last
        expect(strategy.valid?).to eq(true)
      end

      it 'returns false if the attribute does not match' do
        Devise.imap_email_domain = 'gmail.com'
        expect(strategy.valid?).to eq(false)
      end
    end
  end

  describe '#authenticate!' do
    before do
      strategy.valid?

      allow(Devise::Imap::Adapter).to receive(:valid_credentials?).and_return(true)
      allow(User).to receive(:find_for_imap_authentication).and_return(user)

      allow(user).to receive(:after_imap_authentication)
    end

    context 'when a record does not exist for the user' do
      before do
        allow(User).to receive(:find_for_imap_authentication).and_return(nil)

        strategy.authenticate!
      end

      it 'calls `.find_for_imap_authentication` to retrieve the record for the user' do
        expect(User).to have_received(:find_for_imap_authentication)
      end

      it 'does not call Devise::Imap::Adapter#valid_credentials?' do
        expect(Devise::Imap::Adapter).not_to have_received(:valid_credentials?)
      end

      it 'fails and halts further processing', aggregate_failures: true do
        expect(strategy).not_to be_successful
        expect(strategy).to be_halted
      end
    end

    context 'when a record exist for the user' do
      before do
        strategy.authenticate!
      end

      it 'calls `.find_for_imap_authentication` to retrieve the record for the user' do
        expect(User).to have_received(:find_for_imap_authentication)
      end

      it 'calls Devise::Imap::Adapter#valid_credentials?' do
        expect(Devise::Imap::Adapter).to have_received(:valid_credentials?)
      end
    end

    context 'when the IMAP authentication is successful' do
      before { strategy.authenticate! }

      it 'calls the `#after_imap_authentication` hook' do
        expect(user).to have_received(:after_imap_authentication)
      end

      it 'returns success' do
        expect(strategy).to be_successful
      end
    end

    context 'when the IMAP authentication fails' do
      before do
        allow(Devise::Imap::Adapter).to receive(:valid_credentials?).and_return(false)

        strategy.authenticate!
      end

      it 'fails but does not halt processing', aggregate_failures: true do
        expect(strategy).not_to be_successful
        expect(strategy).not_to be_halted
      end
    end
  end
end
