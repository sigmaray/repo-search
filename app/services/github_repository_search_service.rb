class GithubRepositorySearchService
  class InvalidResponseError < StandardError; end

  API_BASE_URL = ENV.fetch('GITHUB_API_BASE_URL')
  API_RAW_CREDENTIALS = ENV['GITHUB_API_CREDENTIALS'].to_s.split(',').freeze

  SEARCH_RESULTS_MAX_AMOUNT = 10

  def search(query, sort: 'stars', order: 'desc')
    raw_response = RestClient.get(
      "#{API_BASE_URL}/search/repositories",
      params: { q: query.strip, sort: sort, order: order },
      **request_headers,
      **basic_auth_header
    )

    transform_response(JSON.parse(raw_response.body, symbolize_names: true))
  rescue JSON::ParserError => err
    raise InvalidResponseError, cause: err
  end

  private

  attr_reader :credentials

  def transform_response(response)
    response.fetch(:items, []).take(SEARCH_RESULTS_MAX_AMOUNT).map do |data_item|
      data_item
        .slice(:name, :html_url, :stargazers_count)
        .merge(owner: data_item.dig(:owner, :login))
    end
  end

  def request_headers
    { accept: 'application/json' }
  end

  def basic_auth_header
    return {} unless credentials.present?

    { 'Authorization' => "Basic #{credentials.base64_encoded}" }
  end

  def credentials
    # TODO: mark credentials as depleted
    parse_raw_credentials(API_RAW_CREDENTIALS.sample)
  end

  def parse_raw_credentials(raw_credentials)
    return unless raw_credentials
    GithubAPICredentials.parse_raw_string(raw_credentials)
  end
end
