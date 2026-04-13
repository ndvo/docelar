class ZipImportService
  SUPPORTED_EXTENSIONS = %w[.zip .tar.gz .tgz].freeze
  MAX_FILE_SIZE = 5.gigabytes
  IMAGE_EXTENSIONS = %w[.png .jpg .jpeg .gif .webp .heic].freeze

  def initialize(gallery)
    @gallery = gallery
    @imported_count = 0
    @skipped_count = 0
  end

  def import(file)
    return error(:unsupported_format) unless supported_format?(file)
    return error(:file_too_large) if too_large?(file)

    temp_dir = nil
    temp_file = nil
    begin
      temp_dir = Dir.mktmpdir('zip_import')
      temp_file = copy_to_temp(file)
      extract_archive(temp_file.path, temp_dir)
      process_images(temp_dir)
      success
    rescue => e
      Rails.logger.error "Zip import failed: #{e.message}"
      error(:import_failed, e.message)
    ensure
      FileUtils.remove_entry(temp_dir) if temp_dir
      FileUtils.remove_entry(temp_file) if temp_file
    end
  end

  def import_from_file(file_path, original_filename)
    @filename = original_filename
    return error(:unsupported_format) unless supported_filename?(original_filename)

    temp_dir = nil
    begin
      temp_dir = Dir.mktmpdir('zip_import')
      extract_archive(file_path, temp_dir)
      process_images(temp_dir)
      success
    rescue => e
      Rails.logger.error "Zip import failed: #{e.message}"
      error(:import_failed, e.message)
    ensure
      FileUtils.remove_entry(temp_dir) if temp_dir
    end
  end

  private

  def supported_format?(file)
    ext = File.extname(file.original_filename.to_s).downcase
    SUPPORTED_EXTENSIONS.include?(ext)
  end

  def supported_filename?(filename)
    ext = File.extname(filename.to_s).downcase
    SUPPORTED_EXTENSIONS.include?(ext)
  end

  def too_large?(file)
    file.size > MAX_FILE_SIZE
  end

  def copy_to_temp(file)
    temp_file = Tempfile.new(['upload', File.extname(file.original_filename)])
    temp_file.binmode
    temp_file.write(file.read)
    temp_file.rewind
    temp_file
  end

  def extract_archive(file_path, dest_dir)
    ext = File.extname(file_path).downcase
    case ext
    when '.zip'
      Zip::File.open(file_path) do |zip|
        zip.each { |entry| entry.extract(dest_dir) if entry.file? }
      end
    when '.tar.gz', '.tgz'
      system("tar", "-xzf", file_path, "-C", dest_dir)
    end
  end

  def process_images(temp_dir)
    image_files = find_image_files(temp_dir)
    Rails.logger.info "[ZipImport] Found #{image_files.count} images"

    if image_files.empty?
      @result = { error: :no_images_found }
      return
    end

    image_files.each { |path| import_image(path) }
    Rails.logger.info "[ZipImport] Done. Imported: #{@imported_count}, Skipped: #{@skipped_count}"
  end

  def find_image_files(dir)
    Dir.glob("#{dir}/**/*").select { |f| File.file?(f) && image_file?(f) }
  end

  def image_file?(path)
    ext = File.extname(path).downcase
    IMAGE_EXTENSIONS.include?(ext)
  end

  def import_image(path)
    filename = File.basename(path)
    Rails.logger.info "[ZipImport] Processing: #{filename} in gallery #{@gallery.id}"

    if Photo.exists?(gallery: @gallery, original_path: filename)
      Rails.logger.info "[ZipImport] Skipping duplicate: #{filename}"
      @skipped_count += 1
      return
    end

    photo = @gallery.photos.new(
      title: filename,
      original_path: filename
    )

    unless photo.valid?
      Rails.logger.error "[ZipImport] Photo invalid: #{photo.errors.full_messages}"
      @skipped_count += 1
      return
    end

    if photo.save
      Rails.logger.info "[ZipImport] Photo saved, attaching file..."
      copy_file_to_attachments(photo, path)
      @imported_count += 1
      Rails.logger.info "[ZipImport] Success: #{filename}"
    else
      Rails.logger.error "[ZipImport] Failed to save: #{photo.errors.full_messages}"
      @skipped_count += 1
    end
  rescue => e
    Rails.logger.error "[ZipImport] Error importing #{path}: #{e.message}"
    @skipped_count += 1
  end

  def copy_file_to_attachments(photo, source_path)
    photo.file.attach(
      io: File.open(source_path),
      filename: File.basename(source_path),
      content_type: mime_type(source_path)
    )
  end

  def mime_type(path)
    ext = File.extname(path).downcase
    {
      '.png' => 'image/png',
      '.jpg' => 'image/jpeg',
      '.jpeg' => 'image/jpeg',
      '.gif' => 'image/gif',
      '.webp' => 'image/webp',
      '.heic' => 'image/heic'
    }[ext] || 'application/octet-stream'
  end

  def success
    { success: true, imported: @imported_count, skipped: @skipped_count }
  end

  def error(code, message = nil)
    { success: false, error: code, message: message }
  end
end
