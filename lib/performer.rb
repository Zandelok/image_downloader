# frozen_string_literal: true

require_relative 'application'

class Performer < Application
  attr_reader :file, :path, :folder_validator, :reader, :validator, :downloader

  def initialize(file, path, folder_validator, reader, validator, downloader)
    @file = file
    @path = path
    @folder_validator = folder_validator
    @reader = reader
    @validator = validator
    @downloader = downloader
  end

  def call
    folder_path = folder_validator.call(path)
    valid_file = reader.call(file)
    valid_urls = validator.call(valid_file)
    downloader.call(valid_urls, folder_path)
  end
end
