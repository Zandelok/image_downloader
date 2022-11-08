# frozen_string_literal: true

require_relative '../../lib/folder_validator'
require_relative '../../lib/reader'
require_relative '../../lib/url_validator'
require_relative '../../lib/image_downloader'
require_relative '../../lib/performer'

describe Performer do
  let(:folder_path) { 'spec/fixtures/test_images/' }
  let(:file) { 'spec/fixtures/test.txt' }
  let(:url) { 'https://s3.eu-central-1.amazonaws.com/nftlaunchpad.com-media/competition/BAYC/1.png' }

  before do
    stub_request(:get, url).to_return(status: 200, headers: { 'Content-Type': 'image/png' })
  end

  after do
    FileUtils.rm_rf("#{folder_path}/.", secure: true)
  end

  describe '#call' do
    subject { described_class.call(file, folder_path, FolderValidator, Reader, UrlValidator, ImageDownloader) }

    context 'when success' do
      it { expect(subject).to eq('All allowed files were successfully downloaded') }
    end
  end
end
