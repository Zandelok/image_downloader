# frozen_string_literal: true

require_relative 'application'
require 'open-uri'
require 'mechanize'

class ImageDownloader < Application
  attr_reader :data

  MAX_SIZE = 10_485_760

  def initialize(data)
    @data = data
  end

  def call
    download_images(data)
  end

  private

  def download_images(image_urls)
    request = Mechanize.new
    request.redirection_limit = 1
    threads = []

    image_urls.each do |image|
      threads << Thread.new { http_download(image, request) }
    end
    threads.each(&:join)
    p 'All allowed files were successfully downloaded'
  end

  def http_download(link, request)
    return unless remote_file_exists?(link, request) && valid_size?(link, request)

    File.open("public/images/#{link.split('/').last}", 'w+') do |file|
      file.write(URI.open(link).read)
    end
  end

  def remote_file_exists?(url, request)
    request.get(url).response['content-type'].start_with?('image')
  end

  def valid_size?(url, request)
    request.get(url).response['content-length'].to_i < MAX_SIZE
  end
end
