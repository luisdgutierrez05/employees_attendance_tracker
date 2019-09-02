# frozen_string_literal: true

# Defines custom exceptions subclasses and inherit from StandardError
module CustomExceptions
  class InvalidRequestError < StandardError; end
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class VerificationError < StandardError; end
  class NotPermittedException < StandardError; end
end
