# frozen_string_literal: true

require_relative 'application'
require 'resolv'

class InternetConnectionValidator < Application
  def call
    internet?
  end

  private

  def internet?
    dns_resolver = Resolv::DNS.new
    begin
      dns_resolver.getaddress('google.com')
    rescue Resolv::ResolvError
      warn 'No Internet connection'
      exit
    end
  end
end
