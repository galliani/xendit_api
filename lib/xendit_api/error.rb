module XenditApi
  # Custom error class for rescuing from all Xendit API errors
  class Error < StandardError; end

  # Raised when Xendit API returns the HTTP status code 400
  class BadRequest < Error; end

  # Raised when Xendit API returns the HTTP status code 401
  class Unauthorized < Error; end

  # Raised when Xendit API returns the HTTP status code 403
  class Forbidden < Error; end

  # Raised when Xendit API returns the HTTP status code 404
  class NotFound < Error; end

  # Raised when Xendit API returns the HTTP status code 500
  class InternalServerError < Error; end

  # Raised when Xendit API returns the HTTP status code 502
  class BadGateway < Error; end

  # Raised when Xendit API returns the HTTP status code 504
  class GatewayTimeout < Error; end
end