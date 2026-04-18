class VideoImportService
  VIDEO_EXTENSIONS = %w[.mp4 .mkv .avi .mov .webm .m4v].freeze

  def self.scan_folder(folder_path)
    return [] unless Dir.exist?(folder_path)

    files = Dir.glob("#{folder_path}/**/*").select do |f|
      VIDEO_EXTENSIONS.include?(File.extname(f).downcase)
    end

    files.map { |f| process_file(f, folder_path) }
  end

  def self.process_file(file_path, base_path)
    filename = File.basename(file_path, ".*")
    relative_path = file_path.sub(base_path, "").delete_prefix("/")
    
    {
      title: clean_title(filename),
      file_path: file_path,
      video_format: File.extname(file_path).delete(".").upcase,
      file_size: File.size(file_path),
      category_path: File.dirname(relative_path)
    }
  end

  def self.clean_title(filename)
    filename
      .gsub(/[._]/, " ")
      .gsub(/\s+/, " ")
      .strip
      .titleize
  end

  def self.import_files(files)
    videos = []
    files.each do |file|
      existing = Video.find_by(file_path: file[:file_path])
      if existing
        videos << existing
        next
      end

      video = Video.create!(
        title: file[:title],
        file_path: file[:file_path],
        video_format: file[:video_format],
        file_size: file[:file_size]
      )
      
      if file[:category_path] && file[:category_path] != "."
        category = find_or_create_category(file[:category_path])
        video.update!(video_category_id: category.id)
      end

      videos << video
    end
    videos
  end

  def self.find_or_create_category(path)
    parts = path.split("/")
    parent = nil
    
    parts.each do |name|
      category = VideoCategory.find_or_create_by!(name: name, parent: parent)
      parent = category
    end
    
    parent
  end
end