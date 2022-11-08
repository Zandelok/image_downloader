# frozen_string_literal: true

require 'mechanize'

class Application
  def self.call(*args)
    new(*args).call
  end

  def exit_with_warning(message)
    warn message
    exit
  end
end
