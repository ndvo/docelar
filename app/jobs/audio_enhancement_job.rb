class AudioEnhancementJob < ApplicationJob
  queue_as :default

  def perform(video_id)
    video = Video.find(video_id)
    return unless video.file.attached?
    return unless video.enhance_audio
    return if video.enhanced_file.attached?
    return if video.audio_completed?

    video.update!(enhance_audio_status: :processing)

    begin
      process_audio(video)
      video.update!(enhance_audio_status: :completed)
      Rails.logger.info "AudioEnhancementJob: Successfully processed video #{video.id}"
    rescue => e
      Rails.logger.error "AudioEnhancementJob: Failed to process video #{video.id}: #{e.message}"
      video.update!(enhance_audio_status: :failed)
    end
  end

  private

  def process_audio(video)
    output_dir = Rails.root.join("tmp", "audio_processing")
    FileUtils.mkdir_p(output_dir)

    input_ext = video.file.filename.to_s.split('.').last || 'mp4'
    input_path = output_dir.join("input_#{video.id}.#{input_ext}")
    output_mp4 = output_dir.join("enhanced_#{video.id}.mp4")

    File.open(input_path, 'wb') do |f|
      video.file.download { |chunk| f.write(chunk) }
    end

    Rails.logger.info "AudioEnhancementJob: Processing video #{video.id}"

    result = AudioEnhancementService.enhance(input_path, output_mp4.to_s)
    enhanced_method = result[:method] || "ffmpeg"

    FileUtils.rm(input_path)
    
    if result[:success] && File.exist?(output_mp4)
      video.update!(
        enhanced_at: Time.current,
        enhanced_method: enhanced_method
      )
      video.enhanced_file.attach(
        io: File.open(output_mp4),
        filename: "enhanced_#{video.file.filename}",
        content_type: video.file.content_type
      )
      FileUtils.rm(output_mp4)
    else
      error_msg = result[:error] || "No output file created"
      raise "Audio processing failed: #{error_msg}"
    end
  end
end