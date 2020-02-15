RSpec.describe GithubAPICredentials, type: :model do
  describe '.parse_raw_string' do
    context 'given a valid raw string (username:token)' do
      let(:username) { 'foo' }
      let(:token) { 'token' }
      let(:raw_credentials) { "#{username}:#{token}" }

      subject(:credentials) { described_class.parse_raw_string(raw_credentials) }

      it 'returns an instance of described class' do
        expect(credentials).to be_a(described_class)
      end

      it 'correctly parses username' do
        expect(credentials.username).to eq(username)
      end

      it 'correctly parses token' do
        expect(credentials.token).to eq(token)
      end
    end

    [nil, 'foo', 'foobar:'].each do |invalid_credentials_string|
      context "given invalid string #{invalid_credentials_string}" do
        subject(:credentials) { described_class.parse_raw_string(invalid_credentials_string) }

        it "raises #{described_class}::InvalidCredentialsString" do
          expect { subject }.to raise_error(described_class::InvalidCredentialsString)
        end
      end
    end
  end

  describe '#base64_encoded' do
    let(:username) { 'foo' }
    let(:token) { 'bar' }

    subject(:credentials) { described_class.new(username: username, token: token) }

    it 'returns concatenated and base64 encoded credentials' do
      expect(Base64.strict_decode64(credentials.base64_encoded)).to eq(
        "#{username}:#{token}"
      )
    end
  end
end
