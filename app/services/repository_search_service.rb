class RepositorySearchService
  def initialize(access_token:)
    @access_token = access_token
  end

  def authenticated?
    access_token.present?
  end

  private

  attr_reader :access_token
end
