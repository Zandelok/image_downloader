# frozen_string_literal: true

require_relative 'application'

class Performer < Application
  attr_reader :input_data_file, :folder_for_downloads_path, :folder_validator, :reader, :url_validator, :downloader

  def initialize(input_data_file, folder_for_downloads_path, folder_validator, reader, url_validator, downloader)
    @input_data_file = input_data_file
    @folder_for_downloads_path = folder_for_downloads_path
    @folder_validator = folder_validator
    @reader = reader
    @url_validator = url_validator
    @downloader = downloader
  end

  def call
    folder_validator.call(folder_for_downloads_path)
    read_file = reader.call(input_data_file)
    valid_urls = url_validator.call(read_file)
    downloader.call(valid_urls, folder_for_downloads_path)
  end
end
