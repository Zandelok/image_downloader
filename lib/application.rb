# frozen_string_literal: true

class Application
  def self.call(*args)
    new(*args).call
  end
end
