# frozen_string_literal: true

require_relative '../../lib/reader'

describe Reader do
  describe '#call' do
    subject { described_class.call(file) }

    context 'when valid file' do
      let(:file) { 'spec/fixtures/test.txt' }
      let(:result) { File.read(file) }

      it 'return a file' do
        expect(subject).to eq(result)
      end
    end

    context 'when ivalid file' do
      let(:file) { 'spec/fixtures/some.txt' }

      it 'raise StandardError' do
        expect { subject }.to raise_error StandardError
      end
    end

    context 'when empty file' do
      let(:file) { 'spec/fixtures/empty_test.txt' }

      it 'return message about empty file' do
        expect(subject).to eq('This file is empty')
      end
    end
  end
end
