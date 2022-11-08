# frozen_string_literal: true

require_relative '../../lib/folder_validator'

describe FolderValidator do
  let(:path_for_downloads) { 'spec/fixtures/test_images/' }

  describe '#call' do
    subject { Dir.exist?(path_for_downloads) }

    before do
      described_class.call(path_for_downloads)
    end

    it 'return or create and return folder path' do
      expect(subject).to eq(true)
    end
  end
end
