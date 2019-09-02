# frozen_string_literal: true

module ControllerSpecHelper # :nodoc:
  def token_generator(user_id)
    JsonWebToken.encode(user_id: user_id)
  end

  def expired_token_generator(user_id)
    JsonWebToken.encode({ user_id: user_id }, (Time.now.to_i - 10))
  end

  def valid_headers(user_id)
    {
      'Authorization' => token_generator(user_id),
      'Content-Type': 'application/vnd.api+json'
    }
  end

  def invalid_headers
    {
      'Authorization' => nil,
      'Content-Type': 'application/vnd.api+json'
    }
  end
end
