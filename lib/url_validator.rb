# frozen_string_literal: true

require_relative 'application'
require 'parallel'

class UrlValidator < Application
  attr_reader :income_urls

  MAX_SIZE = 10_485_760

  def initialize(income_urls)
    @income_urls = income_urls
  end

  def call
    validate_urls
  end

  private

  def validate_urls
    request = Mechanize.new
    request.redirection_limit = 1
    image_urls = []

    valid_urls = income_urls.split.select { |link| valid_url?(link) }.uniq
    Parallel.each(valid_urls, in_threads: 10) do |link|
      image_urls << link if image_urls?(link, request)
    end
    exit_with_warning('No reliable files were found') if image_urls.empty?

    image_urls
  end

  def valid_url?(url)
    url_regexp = %r{\A(http|https)://[a-z0-9]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?\z}ix
    url =~ url_regexp ? true : false
  end

  def image_urls?(url, request)
    response = request.get(url).response
    response['content-type'].start_with?('image') && response['content-length'].to_i < MAX_SIZE
  end
end
