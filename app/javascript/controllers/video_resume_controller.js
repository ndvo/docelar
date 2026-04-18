import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    position: { type: Number, default: 0 }
  }

  connect() {
    this.lastSavedPosition = 0
    this.saveInterval = null
    
    this.element.addEventListener('loadedmetadata', this.onLoadedMetadata.bind(this))
    this.element.addEventListener('play', this.onPlay.bind(this))
    this.element.addEventListener('pause', this.onPause.bind(this))
    this.element.addEventListener('timeupdate', this.onTimeUpdate.bind(this))
    window.addEventListener('beforeunload', this.savePosition.bind(this))
    document.addEventListener('turbo:before-cache', this.savePosition.bind(this))
  }

  disconnect() {
    this.savePosition()
    if (this.saveInterval) clearInterval(this.saveInterval)
  }

  onLoadedMetadata() {
    if (this.positionValue > 0 && this.positionValue < this.element.duration - 5) {
      this.element.currentTime = this.positionValue
    }
  }

  onPlay() {
    this.saveInterval = setInterval(() => this.periodicSave(), 10000)
  }

  onPause() {
    if (this.saveInterval) clearInterval(this.saveInterval)
    this.savePosition()
  }

  onTimeUpdate() {
    if (this.element.currentTime - this.lastSavedPosition >= 5) {
      this.periodicSave()
    }
  }

  periodicSave() {
    if (this.element.currentTime > this.lastSavedPosition + 4) {
      this.lastSavedPosition = Math.floor(this.element.currentTime)
      this.savePosition()
    }
  }

  savePosition() {
    const position = Math.floor(this.element.currentTime)
    if (position <= 0) return

    const videoId = this.element.dataset.videoId
    if (!videoId) return

    fetch(`/videos/${videoId}/update_position`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.content
      },
      body: JSON.stringify({ position: position })
    }).catch(() => {})
  }
}