# frozen_string_literal: true

require_relative 'application'

class ImageDownloader < Application
  attr_reader :data, :path

  def initialize(data, path)
    @data = data
    @path = path
  end

  def call
    download_images(data, path)
  end

  private

  def download_images(image_urls, path_for_downloads)
    threads = []

    image_urls.each do |image|
      file_name = image.split('/').last
      image_name = set_filename(file_name, path_for_downloads)
      multithreading(threads, image, image_name, path_for_downloads)
    end

    threads.each(&:join)
    p 'All allowed files were successfully downloaded'
  end

  def multithreading(threads, image, image_name, path_for_downloads)
    queue = Thread::Queue.new
    num_threads = 5
    Thread.new do
      num_threads.times do
        queue.push(http_download(image, image_name, path_for_downloads))
      end
    end

    threads << Thread.new { num_threads.times { queue.pop } }
  end

  def http_download(link, file_name, path_for_downloads)
    File.write("#{path_for_downloads}#{file_name}", Mechanize.new.get_file(link))
  end

  def set_filename(image_name, path_for_downloads)
    file_names = Dir.new(path_for_downloads.to_s).children
    image_name = file_names.include?(image_name) ? image_name.split('.').join('_new.') : image_name
    file_names.include?(image_name) ? set_filename(image_name, path_for_downloads) : image_name
  end
end
