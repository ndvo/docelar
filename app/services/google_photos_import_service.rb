# frozen_string_literal: true

class GooglePhotosImportService
  def initialize(access_token, gallery)
    @google_photos = GooglePhotosService.new(access_token)
    @gallery = gallery
  end

  def import_album(album_id, album_name = nil)
    album_name ||= "Google Photos Import #{Time.current.strftime('%Y-%m-%d %H:%M')}"
    photos_imported = 0
    page_token = nil

    loop do
      result = @google_photos.list_photos(album_id: album_id, page_token: page_token)
      media_items = result.fetch("mediaItems", [])
      next_page_token = result["nextPageToken"]

      media_items.each do |item|
        import_photo(item)
        photos_imported += 1
      end

      break unless next_page_token
      page_token = next_page_token
    end

    { photos_imported: photos_imported }
  end

  def import_single_photo(media_item_id)
    media_item = @google_photos.get_photo(media_item_id)
    import_photo(media_item)
  end

  private

  def import_photo(media_item)
    return if photo_already_imported?(media_item["id"])

    filename = media_item["filename"]
    temp_file = download_photo(media_item)

    return unless temp_file

    photo = @gallery.photos.create!(
      original_path: filename,
      title: extract_title(filename),
      google_photos_id: media_item["id"]
    )

    photo.file.attach(
      io: temp_file,
      filename: filename,
      content_type: media_item["mimeType"]
    )

    generate_variants(photo)

  ensure
    temp_file&.close
    temp_file&.unlink
  end

  def photo_already_imported?(google_photos_id)
    @gallery.photos.exists?(google_photos_id: google_photos_id)
  end

  def download_photo(media_item)
    download_url = @google_photos.download_url(media_item)
    return nil unless download_url

    begin
      URI.open(download_url)
    rescue OpenURI::HTTPError
      nil
    end
  end

  def extract_title(filename)
    File.basename(filename, File.extname(filename))
        .gsub(/[_-]/, " ")
        .split
        .map(&:capitalize)
        .join(" ")
  end

  def generate_variants(photo)
    photo.ensure_medium_variant
    photo.ensure_grid_variant
  end
end
