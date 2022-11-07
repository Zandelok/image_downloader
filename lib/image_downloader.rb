# frozen_string_literal: true

require_relative 'application'
require 'open-uri'

class ImageDownloader < Application
  attr_reader :data

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
    p 'All allowed files were successfully downloaded'
  end

  def http_download(link)
    File.open("public/images/#{link.split('/').last}", 'w+') do |file|
      file.write(URI.open(link).read)
    end
  end
end
