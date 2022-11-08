# frozen_string_literal: true

require 'open3'

RSpec.describe 'script' do
  let(:stdoutput) { Open3.capture3("./bin/main #{file} #{path_for_downloads}") }
  let(:file) { 'spec/fixtures/test.txt' }
  let(:path_for_downloads) { 'spec/fixtures/test_images/' }
  let(:result) { stdoutput[0] }
  let(:errors) { stdoutput[1] }
  let(:expected_result) { "\"All allowed files were successfully downloaded\"\n" }
  let(:url) { 'https://s3.eu-central-1.amazonaws.com/nftlaunchpad.com-media/competition/BAYC/1.png' }

  before do
    stub_request(:get, url)
  end

  after do
    FileUtils.rm_rf("#{path_for_downloads}/.", secure: true)
  end

  context 'when file not provided' do
    let(:file) {}

    it { expect(errors).to eq("Please, write file name and path for downloads\n") }
  end

  context 'when path for downloads not provided' do
    let(:path_for_downloads) {}

    it { expect(errors).to eq("Please, write file name and path for downloads\n") }
  end

  context 'when invalid file' do
    let(:file) { 'spec/fixtures/some.txt' }

    it { expect(errors).to include('StandardError') }
  end

  context 'when success' do
    it { expect(result).to eq(expected_result) }
  end
end
