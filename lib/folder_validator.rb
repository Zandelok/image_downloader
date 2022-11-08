# frozen_string_literal: true

require_relative 'application'

class FolderValidator < Application
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def call
    create_folder unless folder_exists?
  end

  private

  def folder_exists?
    Dir.exist?(path)
  end

  def create_folder
    Dir.mkdir(path)
  end
end
