# frozen_string_literal: true

require_relative '../../lib/image_downloader'

describe ImageDownloader do
  describe '#call' do
    subject { described_class.call(data) }

    context 'when valid urls exists' do
      let(:data) { ['https://s3.eu-central-1.amazonaws.com/nftlaunchpad.com-media/competition/BAYC/1.png'] }

      it 'download valid files' do
        expect(subject).to eq('All allowed files were successfully downloaded')
      end
    end
  end
end
