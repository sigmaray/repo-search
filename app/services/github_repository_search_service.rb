class GithubRepositorySearchService
  class InvalidResponseError < StandardError; end

  API_BASE_URL = ENV.fetch('GITHUB_API_BASE_URL')

  def initialize(raw_credentials:)
    @credentials = parse_raw_credentials(raw_credentials)
  end

  def search(query, sort: 'stars', order: 'desc')
    raw_response = RestClient.get(
      "#{API_BASE_URL}/search/repositories",
      params: { q: query, sort: sort, order: order },
      headers: { **request_headers, **basic_auth_header }
    )

    response = JSON.parse(raw_response, symbolize_names: true)
  rescue JSON::ParserError => err
    raise InvalidResponseError, cause: err
  end

  private

  attr_reader :credentials

  def request_headers
    { accept: 'application/json' }
  end

  def basic_auth_header
    return {} unless credentials.present?

    { 'Authorization' => "Basic #{credentials.base64_encoded}" }
  end

  def parse_raw_credentials(raw_credentials)
    return unless raw_credentials
    GithubAPICredentials.parse_raw_string(raw_credentials)
  end
end
