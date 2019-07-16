# Devise Imapable

This gem provides a Devise strategy to authenticate a user using an IMAP server.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise_imapable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise_imapable

## Usage

Add the the `:imap_authenticatable` strategy to your user model as shown below.

```ruby
    class User < ActiveRecord::Base

      devise :imap_authenticatable, :database_authenticatable

    end
```

### Options

* The IMAP server address to authenticate with:

  ```ruby
  Devise.imap_email_domain = 'example.com'
  ```

* The domain name that *MUST* be present in the username to allow
  authentication using the defined IMAP server


* The attribute in the User model that contains the username to use to
  authenticate on the IMAP server.

  ```ruby
  Devise.imap_email_attribute = :email
  ```

### Callbacks

* `User.find_for_imap_authentication` to customize resource retrieval for IMAP authentication.
* `User#after_iamp_authentication` to allow further processing after the user has been authenticated.

## Previous Work

This gem was inspirred by the work done by [Josh Kalderimis](https://github.com/joshk) as presented in [devise_imapable](https://github.com/joshk/devise_imapable)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bithium/devise_imapable.

## License

MIT License. Copyright 2019 [Bithium](https://www.bithium.com)

You are not granted rights or licenses to the trademarks of [Bithium](https://www.bithium.com), including without limitation the Bithium name or logo.
