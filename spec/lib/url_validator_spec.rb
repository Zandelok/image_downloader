# frozen_string_literal: true

require_relative '../../lib/url_validator'

describe UrlValidator do
  describe '#call' do
    subject { described_class.call(file) }

    context 'when valid urls exists' do
      let(:file) { File.read('spec/fixtures/test.txt') }
      let(:result) { ['https://s3.eu-central-1.amazonaws.com/nftlaunchpad.com-media/competition/BAYC/1.png'] }

      it 'return valid urls' do
        expect(subject).to eq(result)
      end
    end

    context 'when no valid urls' do
      let(:file) { File.read('spec/fixtures/invalid_urls.txt') }
      let(:result) { 'No reliable files were found' }

      it 'return message about invalid urls' do
        expect(subject).to eq(result)
      end
    end
  end
end
