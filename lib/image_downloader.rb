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
      file_name = image.split('/').last
      image_name = set_filename(file_name)
      threads << Thread.new { http_download(image, image_name) }
    end

    threads.each(&:join)
    p 'All allowed files were successfully downloaded'
  end

  def http_download(link, file_name)
    File.open("public/images/#{file_name}", 'w+') do |file|
      file.write(URI.open(link).read)
    end
  end

  def set_filename(image_name)
    file_names = Dir.new('public/images/').children
    image_name = file_names.include?(image_name) ? image_name.split('.').join('_new.') : image_name
    file_names.include?(image_name) ? set_filename(image_name) : image_name
  end
end
