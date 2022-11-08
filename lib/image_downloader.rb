# frozen_string_literal: true

require_relative 'application'
require 'benchmark'

class ImageDownloader < Application
  attr_reader :image_urls, :path_for_downloads

  def initialize(image_urls, path_for_downloads)
    @image_urls = image_urls
    @path_for_downloads = path_for_downloads
  end

  def call
    download_images
  end

  private

  def download_images
    queue = Queue.new
    threads = image_urls.map do |image|
      file_name = image.split('/').last
      image_name = filename(file_name)
      Thread.new { queue << http_download(image, image_name) }
    end

    threads.each(&:join)
    p 'All allowed files were successfully downloaded'
  end

  def http_download(link, file_name)
    File.write("#{path_for_downloads}#{file_name}", Mechanize.new.get_file(link))
    p "#{file_name} downloaded succesfully"
  end

  def filename(image_name)
    file_names = Dir.new(path_for_downloads.to_s).children
    image_name = file_names.include?(image_name) ? image_name.split('.').join('_new.') : image_name
    file_names.include?(image_name) ? filename(image_name) : image_name
  end
end
