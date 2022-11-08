# frozen_string_literal: true

require_relative 'application'

class FolderValidator < Application
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def call
    folder_exists?(path) ? path : create_folder(path)
  end

  private

  def folder_exists?(path_for_downloads)
    Dir.exist?(path_for_downloads)
  end

  def create_folder(path_for_downloads)
    Dir.mkdir(path_for_downloads)
    path_for_downloads
  end
end
