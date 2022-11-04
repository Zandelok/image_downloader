# frozen_string_literal: true

require_relative 'application'

class Reader < Application
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def call
    raise StandardError unless File.exist?(file_path)

    empty?(File.read(file_path))
  end

  private

  def empty?(file)
    if file.empty?
      warn 'This file is empty'
      exit
    else
      file
    end
  end
end
