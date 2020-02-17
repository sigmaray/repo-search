RSpec.describe GithubRepositorySearchService, type: :model do
  subject(:service) { described_class.new }

  describe '#search' do
    let(:query) { 'rails+language:ruby' }
    let(:response_body) { {} }
    let(:response_mock) { OpenStruct.new(body: JSON.dump(response_body)) }

    before do
      stub_const("#{described_class}::API_RAW_CREDENTIALS", [raw_credentials])
    end

    context 'given credentials were provided' do
      let(:raw_credentials) { 'username:token' }
      let(:credentials) { GithubAPICredentials.parse_raw_string(raw_credentials) }

      let(:response_body) do
        {
          items: 20.times.to_a.map do |i|
            {
              name: "Repo #{i}",
              html_url: "Some URL",
              stargazers_count: rand,
              owner: { login: 'username' },
              foo: 'bar'
            }
          end
        }
      end

      before do
        allow(RestClient).to receive(:get).and_return(response_mock)
      end

      it 'calls RestClient.get with correct params, including Authorization header' do
        expect(RestClient).to receive(:get).with(
          "#{described_class::API_BASE_URL}/search/repositories",
          params: { q: query, sort: 'stars', order: 'desc' },
          accept: 'application/json',
          'Authorization' => "Basic #{credentials.base64_encoded}"
        ).and_return(response_mock)

        service.search(query)
      end

      it 'returns first 10 items of search results' do
        expect(service.search(query).count).to eq(described_class::SEARCH_RESULTS_MAX_AMOUNT)
      end

      it 'transforms the github response to include only required data' do
        expect(service.search(query).map(&:keys).map(&:sort)).to all(
          eq(%i[html_url name owner stargazers_count])
        )
      end
    end

    context 'given no credentials were provided' do
      let(:raw_credentials) { nil }

      it 'calls RestClient.get with correct params, without Authorization header' do
        expect(RestClient).to receive(:get).with(
          "#{described_class::API_BASE_URL}/search/repositories",
          params: { q: query, sort: 'stars', order: 'desc' },
          accept: 'application/json'
        ).and_return(response_mock)

        service.search(query)
      end
    end

    context 'given invalid JSON resonse from Github' do
      let(:raw_credentials) { nil }

      before do
        allow(RestClient).to receive(:get).and_return(OpenStruct.new(body: ''))
      end

      it "raises #{described_class}::InvalidResponseError" do
        expect do
          service.search(query)
        end.to raise_error(described_class::InvalidResponseError)
      end
    end
  end
end
