# frozen_string_literal: true

require_relative '../../lib/image_downloader'

describe ImageDownloader do
  let(:url) { 'https://s3.eu-central-1.amazonaws.com/nftlaunchpad.com-media/competition/BAYC/1.png' }

  before do
    stub_request(:get, url)
  end

  after do
    FileUtils.rm_rf("#{path_for_downloads}/.", secure: true)
  end

  describe '#call' do
    subject { described_class.call(data, path_for_downloads) }
    let(:path_for_downloads) { 'spec/fixtures/test_images/' }

    context 'when valid urls exists' do
      let(:data) { [url] }

      it 'download valid files' do
        expect(subject).to eq('All allowed files were successfully downloaded')
      end
    end
  end
end
