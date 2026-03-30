namespace :photos do
  desc "Generate medium-sized variants for all photos"
  task generate_medium_variants: :environment do
    photos = Photo.all.to_a
    total = photos.count
    puts "Generating medium variants for #{total} photos..."

    photos.each_with_index do |photo, i|
      print "\rProgress: #{i + 1}/#{total} (#{((i + 1) * 100 / total)}%)"
      photo.ensure_medium_variant
    end

    puts "\nDone! Generated #{total} medium variants."
  end

  desc "Generate thumbnails for all photos"
  task generate_thumbnails: :environment do
    puts "Thumbnails already exist in public/galleries_thumbs/"
    puts "If you need to regenerate, delete public/galleries_thumbs/ and run:"
    puts "  Gallery.all.each { |g| g.generate_photos }"
  end
end
