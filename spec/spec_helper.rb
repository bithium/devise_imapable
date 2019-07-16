# frozen_string_literal: true

require 'bundler/setup'
require 'faker'

require 'sqlite3'
require 'active_record'

require 'devise'
require 'devise_imapable'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# ===============================================================================
# Helper Classes
# ===============================================================================

require 'rack/test'
require 'action_controller/railtie'
require 'active_record'
require 'devise/rails/routes'
require 'devise/rails/warden_compat'

ActiveRecord::Base.establish_connection(adapter: :sqlite3, database: ':memory:')

class DeviseCreateUsers < ActiveRecord::Migration[5.2]

  def change
    create_table(:users) do |t|
      t.string :email,              null: false
      t.string :encrypted_password, null: true
      t.timestamps null: false
    end
  end

end

Devise.setup do |config|
  require 'devise/orm/active_record'
  config.secret_key = 'secret_key_base'
end

class TestApp < Rails::Application

  config.root = File.dirname(__FILE__)
  config.session_store :cookie_store, key: 'cookie_store_key'
  secrets.secret_token    = 'secret_token'
  secrets.secret_key_base = 'secret_key_base'
  config.eager_load = false

  config.middleware.use Warden::Manager do |config|
    Devise.warden_config = config
  end

  config.logger = Logger.new($stdout)
  Rails.logger  = config.logger

end

Rails.application.initialize!

DeviseCreateUsers.migrate(:up)

class User < ActiveRecord::Base

  devise :imap_authenticatable

end
