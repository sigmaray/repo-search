class GithubRepositorySearchService
  class InvalidResponseError < StandardError; end
  class RateLimitExceeded < StandardError; end

  API_BASE_URL = ENV.fetch('GITHUB_API_BASE_URL')
  API_RAW_CREDENTIALS = ENV['GITHUB_API_CREDENTIALS']

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
  rescue RestClient::Forbidden => err
    raise RateLimitExceeded,
      cause: err,
      message: formatted_rate_limit_error(err.http_headers[:x_ratelimit_reset])
  end

  private

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
    return unless API_RAW_CREDENTIALS
    GithubAPICredentials.parse_raw_string(API_RAW_CREDENTIALS)
  end

  def formatted_rate_limit_error(ratelimit_reset_header)
    # server time is UTC, no need for conversion
    seconds_until_reset = Integer(ratelimit_reset_header) - Time.zone.now.to_i

    I18n.t(
      'errors.github_rate_limit_exceeded',
      seconds: "#{seconds_until_reset} #{I18n.t('units.time.second', count: seconds_until_reset)}"
    )
  end
end
