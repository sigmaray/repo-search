RSpec.describe RepositorySearchService, type: :model do
  subject(:search_service) { described_class.new(access_token: access_token) }

  let(:access_token) { nil }

  describe '#authenticated?' do
    context 'when access token is present' do
      let(:access_token) { 'TOKEN' }

      it 'returns true' do
        expect(search_service.authenticated?).to eq(true)
      end
    end

    context 'when access token is present' do
      it 'returns true' do
        expect(search_service.authenticated?).to eq(false)
      end
    end
  end
end
