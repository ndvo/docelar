class VideoImportJob < ApplicationJob
  queue_as :default

  def perform(folder_path)
    return unless Dir.exist?(folder_path)

    files = VideoImportService.scan_folder(folder_path)
    videos = VideoImportService.import_files(files)

    Rails.logger.info "VideoImportJob: Imported #{videos.count} videos from #{folder_path}"
  end
end