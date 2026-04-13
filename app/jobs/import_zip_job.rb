class ImportZipJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: :exponentially_longer, attempts: 5

  def perform(gallery_id, file_path, filename)
    gallery = Gallery.find(gallery_id)
    service = ZipImportService.new(gallery)
    result = service.import_from_file(file_path, filename)

    if result[:success]
      ActionCable.server.broadcast(
        "import_channel_#{gallery_id}",
        {
          type: "import_complete",
          imported: result[:imported],
          skipped: result[:skipped],
          gallery_path: gallery_path(gallery)
        }
      )
    else
      ActionCable.server.broadcast(
        "import_channel_#{gallery_id}",
        {
          type: "import_error",
          error: result[:error],
          message: result[:message]
        }
      )
    end
  rescue => e
    Rails.logger.error "ImportZipJob failed: #{e.message}"
    ActionCable.server.broadcast(
      "import_channel_#{gallery_id}",
      {
        type: "import_error",
        error: :job_failed,
        message: e.message
      }
    ) if gallery_id.present?
  end

  private

  def gallery_path(gallery)
    Rails.application.routes.url_helpers.gallery_path(gallery)
  end
end
