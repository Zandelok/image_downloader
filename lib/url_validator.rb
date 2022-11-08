# frozen_string_literal: true

require_relative 'application'

class UrlValidator < Application
  attr_reader :file

  MAX_SIZE = 10_485_760

  def initialize(file)
    @file = file
  end

  def call
    validate_urls(file)
  end

  private

  def validate_urls(file_name)
    request = Mechanize.new
    request.redirection_limit = 1

    valid_urls = file_name.split.select { |link| valid_url?(link) }.uniq
    image_urls = valid_urls.select { |link| remote_file_exists?(link, request) && valid_size?(link, request) }
    if image_urls.empty?
      warn 'No reliable files were found'
      exit
    end

    image_urls
  end

  def valid_url?(url)
    url_regexp = %r{\A(http|https)://[a-z0-9]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?\z}ix
    url =~ url_regexp ? true : false
  end

  def remote_file_exists?(url, request)
    request.get(url).response['content-type'].start_with?('image')
  end

  def valid_size?(url, request)
    request.get(url).response['content-length'].to_i < MAX_SIZE
  end
end
