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
