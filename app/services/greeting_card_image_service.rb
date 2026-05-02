require "mini_magick"
require "fileutils"

class GreetingCardImageService
  FONT_DIR = "/usr/share/fonts/truetype"
  CACHE_DIR = "/tmp/greeting_cards"

  DEFAULT_WIDTH = 1080
  DEFAULT_HEIGHT = 1920
  PADDING = 60
  TITLE_FONT_SIZE = 72
  MESSAGE_FONT_SIZE = 48

  PRESET_SIZES = {
    "whatsapp" => { width: 1080, height: 1920 },
    "instagram_story" => { width: 1080, height: 1920 },
    "instagram_portrait" => { width: 1080, height: 1350 },
    "instagram_square" => { width: 1080, height: 1080 },
    "facebook" => { width: 1200, height: 630 },
    "email" => { width: 600, height: 800 },
    "print_4x6" => { width: 600, height: 900 },
    "print_5x7" => { width: 750, height: 1050 }
  }.freeze

  FOLD_CONFIGS = {
    "none" => { panels: 1 },
    "half" => { panels: 2 },
    "tri" => { panels: 3 }
  }.freeze

  FONTS = {
    "dejavu_sans" => "dejavu/DejaVuSans.ttf",
    "dejavu_serif" => "dejavu/DejaVuSerif.ttf",
    "dejavu_mono" => "dejavu/DejaVuSansMono.ttf",
    "lato" => "lato/Lato-Regular.ttf",
    "lato_black" => "lato/Lato-Black.ttf"
  }.freeze

  class << self
    def generate(greeting_card)
      ensure_cache_dir
      
      width, height = dimensions_for(greeting_card)
      cache_key = cache_key_for(greeting_card)
      cached_path = "#{CACHE_DIR}/#{cache_key}.png"

      return MiniMagick::Image.open(cached_path) if File.exist?(cached_path)

      background_image = get_background_image(greeting_card)
      temp_path = "/tmp/greeting_card_base_#{Process.pid}_#{Time.current.to_i}.png"

      system("convert -size #{width}x#{height} xc:white #{temp_path}")
      card = MiniMagick::Image.open(temp_path)
      File.delete(temp_path)

      if background_image
        scaled_bg = scale_background_to_card(background_image, width, height)
        card = composite_background(card, scaled_bg)
      end

      card = add_title_text(card, greeting_card.title, greeting_card.font_family, height)
      card = add_message_text(card, greeting_card.message, greeting_card.font_family, height) if greeting_card.message.present?

      card.write(cached_path)
      card = MiniMagick::Image.open(cached_path)

      card
    end

    def dimensions_for(greeting_card)
      preset = greeting_card.preset_size || "whatsapp"
      size = PRESET_SIZES[preset] || PRESET_SIZES["whatsapp"]
      [size[:width], size[:height]]
    end

    def thumbnail(greeting_card)
      ensure_cache_dir
      base_key = cache_key_for(greeting_card)
      thumb_path = "#{CACHE_DIR}/#{base_key}_thumb.png"

      return MiniMagick::Image.open(thumb_path) if File.exist?(thumb_path)

      full = generate(greeting_card)
      full_path = full.path

      system("convert #{full_path} -resize 300x400 #{thumb_path}")

      MiniMagick::Image.open(thumb_path)
    end

    def invalidate(greeting_card)
      ensure_cache_dir
      cache_key = cache_key_for(greeting_card)
      File.delete("#{CACHE_DIR}/#{cache_key}.png") rescue nil
      File.delete("#{CACHE_DIR}/#{cache_key}_thumb.png") rescue nil
    end

    private

    def ensure_cache_dir
      FileUtils.mkdir_p(CACHE_DIR) unless Dir.exist?(CACHE_DIR)
    end

def cache_key_for(greeting_card)
      bg = greeting_card.letter_background
      bg_blob_key = bg&.image&.blob&.key
      filters_hash = bg&.filter_stack&.dig("filters")&.map { |f| f["type"] }&.join(",") || ""

      "#{greeting_card.id}-#{greeting_card.font_family}-#{greeting_card.preset_size}-#{greeting_card.fold_type}-#{bg_blob_key}-#{Digest::MD5.hexdigest(filters_hash)}-#{greeting_card.updated_at.to_i}"
    end

    def scale_background_to_card(image, target_width, target_height)
      bg_width = image.width
      bg_height = image.height

      target_ratio = target_width.to_f / target_height.to_f
      bg_ratio = bg_width.to_f / bg_height.to_f

      if bg_ratio > target_ratio
        new_height = target_height
        new_width = (bg_width * target_height.to_f / bg_height).to_i
      else
        new_width = target_width
        new_height = (bg_height * target_width.to_f / bg_width).to_i
      end

      image.resize("#{new_width}x#{new_height}")
    end

    def get_background_image(greeting_card)
      return nil unless greeting_card.letter_background&.image&.attached?

      blob = greeting_card.letter_background.image.blob
      file_path = ActiveStorage::Blob.service.path_for(blob.key)
      image = MiniMagick::Image.open(file_path)

      filters = greeting_card.letter_background.filters
      ImageFilterService.apply_filters(image, filters)
    end

    def scale_background_to_card(image, target_width, target_height)
      bg_width = image.width
      bg_height = image.height

      target_ratio = target_width.to_f / target_height.to_f
      bg_ratio = bg_width.to_f / bg_height.to_f

      if bg_ratio > target_ratio
        new_height = target_height
        new_width = (bg_width * target_height.to_f / bg_height).to_i
      else
        new_width = target_width
        new_height = (bg_height * target_width.to_f / bg_width).to_i
      end

      image.resize("#{new_width}x#{new_height}")
    end

    def composite_background(card, background)
      card_path = card.path
      bg_path = background.path
      output_path = "/tmp/greeting_card_#{Process.pid}_#{Time.current.to_i}.png"

      system("convert #{card_path} #{bg_path} -gravity center -composite #{output_path}")

      result = MiniMagick::Image.open(output_path)
      File.delete(output_path) rescue nil
      result
    end

    def add_title_text(card, title, font_family = nil)
      return card unless title

      font = font_for(font_family)

      card_path = card.path
      output_path = "/tmp/greeting_card_title_#{Process.pid}_#{Time.current.to_i}.png"

      system("convert #{card_path} -gravity north -font #{font} -pointsize #{TITLE_FONT_SIZE} " \
             "-fill white -stroke black -strokewidth 2 " \
             "-annotate 0x0+0+#{PADDING + TITLE_FONT_SIZE} '#{title.gsub("'", "\\'")}' #{output_path}")

      MiniMagick::Image.open(output_path)
    ensure
      File.delete(output_path) rescue nil
    end

    def add_message_text(card, message, font_family = nil)
      return card unless message

      font = font_for(font_family)

      wrapped_message = wrap_text(message, 40)
      lines = wrapped_message.lines
      line_height = MESSAGE_FONT_SIZE * 1.5
      total_text_height = lines.count * line_height
      start_y = (CARD_HEIGHT - total_text_height) / 2

      card_path = card.path
      output_path = "/tmp/greeting_card_msg_#{Process.pid}_#{Time.current.to_i}.png"

      cmd = "convert #{card_path} -gravity north -font #{font} -pointsize #{MESSAGE_FONT_SIZE} " \
            "-fill white -stroke black -strokewidth 1"

      lines.each_with_index do |line, i|
        y_pos = start_y + (i * line_height)
        cmd += " -annotate 0x0+0+#{y_pos} '#{line.strip.gsub("'", "\\'")}'"
      end

      cmd += " #{output_path}"
      system(cmd)

      MiniMagick::Image.open(output_path)
    ensure
      File.delete(output_path) rescue nil
    end

    def font_for(font_family)
      return default_font unless font_family.present?

      # Check if it's a custom font ID (numeric)
      if font_family.to_s.match?(/^\d+$/)
        font = Font.active.find_by(id: font_family)
        if font&.file.attached?
          # Copy to temp file for ImageMagick to use
          return copy_font_to_temp(font)
        end
      end

      # Check system fonts
      font_path = FONTS[font_family]
      return "#{FONT_DIR}/#{font_path}" if font_path
      default_font
    end

    def copy_font_to_temp(font)
      temp_path = "/tmp/font_#{font.id}_#{font.file.filename}"
      return temp_path if File.exist?(temp_path)
      
      FileUtils.cp(font.font_path, temp_path)
      temp_path
    end

    def default_font
      "#{FONT_DIR}/dejavu/DejaVuSans.ttf"
    end

    def wrap_text(text, max_width)
      text.gsub(/.{1,#{max_width}}(?:\s+|$)/) { |m| m.strip + "\n" }
    end
  end
end