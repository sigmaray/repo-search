require 'base64'

class GithubAPICredentials
  class InvalidCredentialsString < ArgumentError; end

  RAW_CREDENTIALS_REGEXP = %r{\A([\S]{2,}:[\S]+)\z}.freeze

  class << self
    def parse_raw_string(raw_credentials)
      raw_credentials = raw_credentials.to_s
      validate_raw_credentials_string!(raw_credentials)

      username, token = raw_credentials.split(':')
      new(username: username, token: token)
    end

    private

    def validate_raw_credentials_string!(raw_credentials)
      return if raw_credentials.match?(RAW_CREDENTIALS_REGEXP)

      raise InvalidCredentialsString, "Invalid credentials string: #{raw_credentials}"
    end
  end

  attr_reader :username, :token

  def initialize(username:, token:)
    @username = username
    @token = token
  end

  def base64_encoded
    Base64.strict_encode64("#{username}:#{token}")
  end
end
