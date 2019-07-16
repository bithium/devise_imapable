# frozen_string_literal: true

require 'rack/test'
require 'action_controller/railtie'
require 'active_record'
require 'devise/rails/routes'
require 'devise/rails/warden_compat'

ActiveRecord::Base.establish_connection(adapter: :sqlite3, database: ':memory:')

class DeviseCreateUsers < ActiveRecord::Migration[5.2]

  def change
    create_table(:users) do |t|
      t.string :email, null: false

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

Rails.application.routes.draw do
  devise_for :users

  # get '/' => 'test#index'
end

# class ApplicationController < ActionController::Base
# end

# class TestController < ApplicationController

#   include Rails.application.routes.url_helpers

#   before_action :authenticate_user!

#   def index
#     render plain: 'Home'
#   end

# end

def env_with_params(path = '/', params = {}, env = {})
  method = params.delete(:method) || 'GET'
  env = { 'HTTP_VERSION' => '1.1', 'REQUEST_METHOD' => method.to_s }.merge(env)
  Rack::MockRequest.env_for("#{path}?#{Rack::Utils.build_query(params)}", env)
end
