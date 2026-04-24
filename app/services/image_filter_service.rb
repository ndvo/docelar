require "mini_magick"

class ImageFilterService
  PRESETS = {
    classic: [
      { type: "sepia", params: {} },
      { type: "vignette", params: { strength: 30 } }
    ],
    modern: [
      { type: "blur", params: { sigma: 2 } },
      { type: "brightness", params: { brightness: 80 } }
    ],
    vintage: [
      { type: "grayscale", params: {} },
      { type: "contrast", params: { contrast: 1.3 } }
    ],
    soft: [
      { type: "blur", params: { sigma: 1 } },
      { type: "brightness", params: { brightness: 110 } }
    ],
    bold: [
      { type: "contrast", params: { contrast: 1.4 } },
      { type: "vignette", params: { strength: 40 } }
    ],
    sepia_light: [
      { type: "sepia", params: {} }
    ],
    dramatic: [
      { type: "contrast", params: { contrast: 1.5 } },
      { type: "brightness", params: { brightness: 70 } },
      { type: "vignette", params: { strength: 50 } }
    ]
  }.freeze

  class << self
    def presets
      PRESETS
    end

    def apply_preset(preset_name)
      PRESETS[preset_name.to_sym]&.map(&:dup)
    end

    def preset_labels
      {
        classic: "Clássico",
        modern: "Moderno",
        vintage: "Vintage",
        soft: "Suave",
        bold: "Dramático",
        sepia_light: "Sépia Leve",
        dramatic: "Dramático"
      }
    end

    def apply_filters(image, filters)
      return image if filters.blank?
      return image unless filters.is_a?(Array)

      filtered = image
      filters.each do |filter|
        filtered = apply_filter(filtered, filter)
      end
      filtered
    end

    def apply_filter(image, filter)
      return image unless filter.is_a?(Hash)
      
      filter = filter.with_indifferent_access if filter.respond_to?(:with_indifferent_access)
      type = filter[:type].to_s if filter[:type]
      params = filter[:params] || {}
      Rails.logger.info "apply_filter: type=#{type}, params=#{params.inspect}"

      case type
      when "blur" then apply_blur(image, params)
      when "grayscale" then apply_grayscale(image, params)
      when "sepia" then apply_sepia(image, params)
      when "vignette" then apply_vignette(image, params)
      when "brightness" then apply_brightness(image, params)
      when "contrast" then apply_contrast(image, params)
      when "negate" then apply_negate(image, params)
      when "black" then apply_black(image, params)
      when "vintage" then apply_vintage(image, params)
      else
        image
      end
    end

    def apply_blur(image, params)
      sigma = (params[:sigma].to_f * 2).to_i
      image.blur("0x#{sigma}")
    end

    def apply_grayscale(image, params)
      image.colorspace("Gray")
    end

    def apply_sepia(image, params)
      image.modulate(saturation: 30)
    end

    def apply_vignette(image, params)
      # Skip - problematic
      image
    end

    def apply_brightness(image, params)
      brightness = params[:brightness].to_f / 100.0 * 100 rescue 100
      image.modulate("100,100,#{brightness}")
    end

    def apply_contrast(image, params)
      contrast = params[:contrast].to_f rescue 1.0
      if contrast > 1.0
        image.contrast
      end
      image
    end

    def apply_negate(image, params)
      image.negate
    end

    def apply_black(image, params)
      Rails.logger.info "APPLY_BLACK called"
      image.background_color = "black"
      image.flatten
      image
    end

    def apply_vintage(image, params)
      image.modulate("100,70,80").contrast
    end
  end
end