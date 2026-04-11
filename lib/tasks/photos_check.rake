# frozen_string_literal: true

require "shellwords"

# This script is run via rake, which already loads the Rails environment

namespace :photos do
  desc "Check gallery images for missing thumbnails and variants"
  task :check, [:gallery_id] => :environment do |_t, args|
    gallery_id = args[:gallery_id]

    if gallery_id
      galleries = [Gallery.find(gallery_id)]
    else
      galleries = Gallery.all
    end

    issues = []

    galleries.each do |gallery|
      puts "\n=== Gallery: #{gallery.name} (ID: #{gallery.id}) ==="

      gallery.photos.each do |photo|
        photo_issues = []

        original_path = Rails.root.join("galleries", gallery.folder_name, photo.original_path)
        thumb_path = Rails.root.join("public", photo.url_thumb_path)
        medium_path = photo.fs_medium_path

        unless File.exist?(original_path)
          photo_issues << "Original missing: #{photo.original_path}"
        end

        unless File.exist?(thumb_path)
          photo_issues << "Thumbnail missing: #{photo.url_thumb_path}"
        end

        unless File.exist?(medium_path)
          photo_issues << "Medium variant missing: #{photo.medium_path}"
        end

        if photo_issues.any?
          issues << { photo: photo, gallery: gallery, issues: photo_issues }
          photo_issues.each { |issue| puts "  ✗ #{issue}" }
        else
          puts "  ✓ #{photo.original_path}"
        end
      end
    end

    puts "\n=== Summary ==="
    puts "Total galleries checked: #{galleries.count}"
    puts "Total photos with issues: #{issues.count}"

    if issues.any?
      puts "\nIssues found:"
      issues.each do |item|
        puts "  Gallery '#{item[:gallery].name}', Photo ID #{item[:photo].id}:"
        item[:issues].each { |issue| puts "    - #{issue}" }
      end
      puts "\nTo regenerate thumbnails, run: rake photos:generate_thumbnails"
    else
      puts "All images are present!"
    end
  end

  desc "Generate missing thumbnails for all photos"
  task :fix_missing, [:gallery_id] => :environment do |_t, args|
    gallery_id = args[:gallery_id]

    if gallery_id
      galleries = [Gallery.find(gallery_id)]
    else
      galleries = Gallery.all
    end

    fixed = 0
    errors = []

    galleries.each do |gallery|
      puts "\n=== Processing: #{gallery.name} ==="

      gallery.photos.each do |photo|
        src = Rails.root.join("galleries", gallery.folder_name, photo.original_path)

        unless File.exist?(src)
          errors << "Original missing: #{src}"
          next
        end

        thumb_dst = Rails.root.join("public", photo.url_thumb_path)
        unless File.exist?(thumb_dst)
          thumb_dir = File.dirname(thumb_dst)
          FileUtils.mkdir_p(thumb_dir)

          cmd = ["convert", "-resize", "200x200>", "-quality", "85", src.to_s, thumb_dst.to_s]
          if system(*cmd)
            puts "  ✓ Thumbnail: #{photo.original_path}"
            fixed += 1
          else
            errors << "Failed to create thumbnail for: #{photo.original_path}"
          end
        end

        medium_dst = photo.fs_medium_path
        unless File.exist?(medium_dst)
          medium_dir = File.dirname(medium_dst)
          FileUtils.mkdir_p(medium_dir)

          cmd = ["convert", "-resize", "1200x1200>", "-quality", "85", src.to_s, medium_dst.to_s]
          if system(*cmd)
            puts "  ✓ Medium: #{photo.original_path}"
            fixed += 1
          else
            errors << "Failed to create medium variant for: #{photo.original_path}"
          end
        end
      end
    end

    puts "\n=== Summary ==="
    puts "Fixed: #{fixed} images"

    if errors.any?
      puts "\nErrors:"
      errors.each { |e| puts "  ✗ #{e}" }
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Usage:"
  puts "  rake photos:check              # Check all galleries"
  puts "  rake photos:check[gallery_id] # Check specific gallery"
  puts "  rake photos:fix_missing               # Fix all missing images"
  puts "  rake photos:fix_missing[gallery_id]   # Fix specific gallery"
end
