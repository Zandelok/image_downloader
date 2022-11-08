# frozen_string_literal: true

require_relative 'application'

class Reader < Application
  attr_reader :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def call
    raise StandardError unless File.exist?(file_path)

    file ||= read_file
    file.empty? ? exit_with_warning('This file is empty') : file
  end

  private

  def read_file
    File.read(file_path)
  end
end
