# frozen_string_literal: true

require_relative 'application'

class UrlValidator < Application
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    parser(file)
  end

  private

  def parser(file_name)
    valid_urls = file_name.split.select { |link| valid_url?(link) }.uniq
    if valid_urls.empty?
      warn 'No reliable addresses were found'
      exit
    end

    valid_urls
  end

  def valid_url?(url)
    url_regexp = %r{\A(http|https)://[a-z0-9]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?\z}ix
    url =~ url_regexp ? true : false
  end
end
