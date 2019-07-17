# frozen_string_literal: true

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

  describe '#imap_password' do
    it 'is present on the User model' do
      expect(User.new).to respond_to(:imap_password)
    end
  end

  describe '#imap_password=' do
    it 'is present on the User model' do
      expect(User.new).to respond_to('imap_password='.to_sym)
    end
  end
end
