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

  def self.enhance(input_path, output_path)
    return { success: false, error: "FFmpeg not available" } unless ffmpeg_available?

    if hush_available? && model_available?
      enhance_with_hush(input_path, output_path)
    else
      enhance_with_ffmpeg(input_path, output_path)
    end
  end

  def self.enhance_with_hush(input_path, output_path)
    output_dir = Rails.root.join("tmp", "audio_processing")
    FileUtils.mkdir_p(output_dir)

    temp_16k = output_dir.join("input_#{Time.current.to_i}.wav")

    resample_cmd = "ffmpeg -y -i '#{input_path}' -ar 16000 -ac 1 '#{temp_16k}' 2>&1"
    stdout, stderr, status = Open3.capture3(resample_cmd)
    unless status&.success? && File.exist?(temp_16k)
      Rails.logger.warn "AudioEnhancementService: Resample failed: #{stderr[0..200]}"
      return enhance_with_ffmpeg(input_path, output_path)
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
      return enhance_with_ffmpeg(input_path, output_path)
    end

    base_name = File.basename(input_path, '.*')
    video_dir = File.dirname(input_path)
    original_video = Dir.glob("#{video_dir}/#{base_name}.*").find { |f| f =~ /\.(mp4|mov|mkv|avi)$/i }

    if original_video && File.exist?(original_video)
      cmd = "ffmpeg -y -i '#{original_video}' -i '#{output_wav}' -c:v copy -c:a aac -b:a 192k '#{output_path}' 2>&1"
      stdout2, stderr2, status2 = Open3.capture3(cmd)

      if status2&.success?
        Rails.logger.info "AudioEnhancementService: Hush AI enhancement successful (video with enhanced audio)"
      else
        Rails.logger.warn "AudioEnhancementService: Video merge failed, using enhanced audio only"
        FileUtils.mv(output_wav, output_path)
      end
    else
      FileUtils.mv(output_wav, output_path)
      Rails.logger.info "AudioEnhancementService: Hush AI enhancement successful (audio only)"
    end

    { success: true, method: "hush" }
  rescue => e
    Rails.logger.error "AudioEnhancementService Hush error: #{e.message}"
    enhance_with_ffmpeg(input_path, output_path)
  end

  def self.enhance_with_ffmpeg(input_path, output_path)
    cmd = "ffmpeg -y -i '#{input_path}' -af 'highpass=f=300,lowpass=f=3400,afftdn=nf=-25' -c:v copy -c:a aac -b:a 192k '#{output_path}' 2>&1"
    stdout, stderr, status = Open3.capture3(cmd)

    if status&.success?
      { success: true, method: "ffmpeg" }
    else
      { success: false, error: "FFmpeg failed: #{stderr}" }
    end
  rescue => e
    { success: false, error: e.message }
  end
end