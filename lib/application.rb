# frozen_string_literal: true

require 'mechanize'

class Application
  def self.call(*args)
    new(*args).call
  end
end
