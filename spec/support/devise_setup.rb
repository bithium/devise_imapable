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
end

def env_with_params(path = '/', params = {}, env = {})
  method = params.delete(:method) || 'GET'
  env = { 'HTTP_VERSION' => '1.1', 'REQUEST_METHOD' => method.to_s }.merge(env)
  Rack::MockRequest.env_for("#{path}?#{Rack::Utils.build_query(params)}", env)
end
