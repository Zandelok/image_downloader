# frozen_string_literal: true

require_relative 'application'
require 'open-uri'
require 'faraday'

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
    threads = []
    image_urls.each do |image|
      threads << Thread.new { http_download(image) }
    end
    threads.each(&:join)
  end

  def http_download(link)
    return unless remote_file_exists?(link) && valid_size?(link)

    File.open("public/images/#{link.split('/').last}", 'w+') do |file|
      file.write(URI.open(link).read)
    end
  end

  def remote_file_exists?(url)
    Faraday.get(url).headers['content-type'].start_with?('image')
  end

  def valid_size?(url)
    Faraday.get(url).headers['content-length'].to_i < MAX_SIZE
  end
end
