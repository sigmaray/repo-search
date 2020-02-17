module API::V1
  class GithubRepositorySearchesController < BaseController
    def create
      search_service = GithubRepositorySearchService.new
      render json: search_service.search(query_param), status: :created
    rescue GithubRepositorySearchService::RateLimitExceeded => err
      render json: { error: err.message }, status: :forbidden
    end

    private

    def query_param
      params.require(:query)
    end
  end
end
