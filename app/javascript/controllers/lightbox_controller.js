import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lightbox", "image"]

  open(event) {
    const card = event.currentTarget
    const img = card.querySelector('img')
    const lightbox = this.lightboxTarget

    this.lightboxTarget.querySelector('img').src = img.src.replace(/(\/[^/]+)\/[^/]+$/, '$1/full')
    this.lightboxTarget.classList.add('active')
    document.body.style.overflow = 'hidden'
  }

  close() {
    this.lightboxTarget.classList.remove('active')
    document.body.style.overflow = ''
  }

  prev() {
    // Navigate to previous photo
    const currentSrc = this.lightboxTarget.querySelector('img').src
    const cards = document.querySelectorAll('.photo-card')
    // Implementation for navigation
  }

  next() {
    // Navigate to next photo
    const currentSrc = this.lightboxTarget.querySelector('img').src
    const cards = document.querySelectorAll('.photo-card')
    // Implementation for navigation
  }

  connect() {
    document.addEventListener('keydown', (e) => {
      if (!this.lightboxTarget.classList.contains('active')) return
      if (e.key === 'Escape') this.close()
      if (e.key === 'ArrowLeft') this.prev()
      if (e.key === 'ArrowRight') this.next()
    })
  }
}
