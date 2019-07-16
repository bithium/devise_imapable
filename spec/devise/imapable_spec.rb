# frozen_string_literal: true

require 'spec_helper'
require 'devise_setup'

RSpec.describe Devise::Imapable do
  it 'has a version number' do
    expect(Devise::Imapable::VERSION).not_to be nil
  end

  it 'adds the `imap_authenticatable` strategy to Warden::Strategies' do
    expect(Warden::Strategies[:imap_authenticatable])
      .to eq(Devise::Strategies::ImapAutheticable)
  end
end
