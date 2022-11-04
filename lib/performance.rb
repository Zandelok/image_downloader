# frozen_string_literal: true

require_relative 'application'

class Performance < Application
  attr_reader :file, :reader, :validator, :downloader

  def initialize(file, reader, validator, downloader)
    @file = file
    @reader = reader
    @validator = validator
    @downloader = downloader
  end

  def call
    valid_file = reader.call(file)
    valid_urls = validator.call(valid_file)
    downloader.call(valid_urls)
  end
end
