module API::V1
  class GithubRepositorySearchesController < BaseController
    def create
      search_service = GithubRepositorySearchService.new(raw_credentials: nil)
      render json: search_service.search(query_param)
    end

    private

    def query_param
      params.require(:query)
    end
  end
end
