require 'open3'
require 'tempfile'
require 'fileutils'

class AudioEnhancementService
  HUSH_PATH = Rails.root.join('..', 'Hush')
  MODEL_PATH = HUSH_PATH.join('deployment', 'models', 'model_best.ckpt')
  INFER_SCRIPT = HUSH_PATH.join('scripts', 'infer_single.py')

  def self.hush_available?
    File.directory?(HUSH_PATH) && File.exist?(INFER_SCRIPT)
  end

  def self.model_available?
    File.exist?(MODEL_PATH)
  end

  def self.ffmpeg_available?
    cmd = "ffmpeg -version 2>&1"
    stdout, stderr, status = Open3.capture3(cmd)
    status&.success?
  end

  def self.enhance(input_path, output_path, crop: nil)
    return { success: false, error: "FFmpeg not available" } unless ffmpeg_available?

    if hush_available? && model_available?
      enhance_with_hush(input_path, output_path, crop: crop)
    else
      enhance_with_ffmpeg(input_path, output_path, crop: crop)
    end
  end

  def self.enhance_with_hush(input_path, output_path, crop: nil)
    output_dir = Rails.root.join("tmp", "audio_processing")
    FileUtils.mkdir_p(output_dir)

    crop_filter = crop_filter_string(crop)

    temp_16k = output_dir.join("input_#{Time.current.to_i}.wav")

    preprocess_cmd = "ffmpeg -y -i '#{input_path}' #{crop_filter} -ar 16000 -ac 1 '#{temp_16k}' 2>&1"
    stdout, stderr, status = Open3.capture3(preprocess_cmd)
    unless status&.success? && File.exist?(temp_16k)
      Rails.logger.warn "AudioEnhancementService: Preprocess failed: #{stderr[0..200]}"
      return enhance_with_ffmpeg(input_path, output_path, crop: crop)
    end

    Rails.logger.info "AudioEnhancementService: Running Hush AI"

    output_wav = output_dir.join("hush_enhanced_#{Time.current.to_i}.wav")

    cmd = "python3 '#{INFER_SCRIPT}' --checkpoint '#{MODEL_PATH}' --input '#{temp_16k}' --output '#{output_wav}' 2>&1"
    Rails.logger.info "AudioEnhancementService: #{cmd}"

    stdout, stderr, status = Open3.capture3(cmd)

    FileUtils.rm(temp_16k) if File.exist?(temp_16k)

    unless status&.success? && File.exist?(output_wav)
      Rails.logger.warn "AudioEnhancementService: Hush AI failed: #{stderr[0..300]}"
      FileUtils.rm(output_wav) if File.exist?(output_wav)
      return enhance_with_ffmpeg(input_path, output_path, crop: crop)
    end

    merged_video = merge_audio_with_video(input_path, output_wav, crop_filter, output_path)

    if merged_video
      { success: true, method: "hush" }
    else
      FileUtils.mv(output_wav, output_path)
      { success: true, method: "hush" }
    end
  rescue => e
    Rails.logger.error "AudioEnhancementService Hush error: #{e.message}"
    enhance_with_ffmpeg(input_path, output_path, crop: crop)
  end

  def self.enhance_with_ffmpeg(input_path, output_path, crop: nil)
    crop_filter = crop_filter_string(crop)

    cmd = "ffmpeg -y -i '#{input_path}' #{crop_filter} -af 'highpass=f=300,lowpass=f=3400,afftdn=nf=-25' -c:v copy -c:a aac -b:a 192k '#{output_path}' 2>&1"
    stdout, stderr, status = Open3.capture3(cmd)

    if status&.success?
      { success: true, method: "ffmpeg" }
    else
      { success: false, error: "FFmpeg failed: #{stderr}" }
    end
  rescue => e
    { success: false, error: e.message }
  end

  def self.crop_filter_string(crop, input_path = nil)
    return "" unless crop
    return "" unless crop[:width] && crop[:height]
    return "" if crop[:width] <= 0 || crop[:height] <= 0

    x = crop[:x] || 0
    y = crop[:y] || 0
    w = crop[:width]
    h = crop[:height]

    if input_path && (crop[:display_width] || crop[:display_height])
      video_dims = video_dimensions(input_path)
      if video_dims
        scale_x = video_dims[:width].to_f / crop[:display_width]
        scale_y = video_dims[:height].to_f / crop[:display_height]
        x = (x * scale_x).round
        y = (y * scale_y).round
        w = (w * scale_x).round
        h = (h * scale_y).round
        Rails.logger.info "AudioEnhancementService: Scaled crop from display #{crop[:display_width]}x#{crop[:display_height]} to actual #{video_dims[:width]}x#{video_dims[:height]}: #{x},#{y},#{w},#{h}"
      end
    end

    " -vf crop=#{w}:#{h}:#{x}:#{y} "
  end

  def self.video_dimensions(input_path)
    cmd = "ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 '#{input_path}' 2>&1"
    stdout, stderr, status = Open3.capture3(cmd)
    return nil unless status&.success? && stdout.present?
    parts = stdout.strip.split(',')
    return nil unless parts.size == 2
    { width: parts[0].to_i, height: parts[1].to_i }
  rescue => e
    nil
  end

  def self.merge_audio_with_video(input_video, audio_wav, crop_filter, output_path)
    return nil unless File.exist?(input_video)

    cmd = "ffmpeg -y -i '#{input_video}' -i '#{audio_wav}' #{crop_filter} -c:v copy -c:a aac -b:a 192k '#{output_path}' 2>&1"
    stdout, stderr, status = Open3.capture3(cmd)
    FileUtils.rm(audio_wav) if File.exist?(audio_wav)

    if status&.success?
      Rails.logger.info "AudioEnhancementService: Merged audio with video"
      true
    else
      Rails.logger.warn "AudioEnhancementService: Merge failed: #{stderr[0..200]}"
      nil
    end
  end
end