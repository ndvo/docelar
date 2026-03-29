import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lightbox", "image"]

  initialize() {
    this.currentIndex = 0
    this.photos = []
  }

  connect() {
    this.collectPhotos()
    this.setupKeyboard()
  }

  collectPhotos() {
    const cards = this.element.querySelectorAll('.photo-card')
    this.photos = Array.from(cards).map(card => card.dataset.photoSrc || '')
  }

  setupKeyboard() {
    document.addEventListener('keydown', (e) => {
      if (!this.lightboxTarget.classList.contains('active')) return
      if (e.key === 'Escape') this.close()
      if (e.key === 'ArrowLeft') this.prev()
      if (e.key === 'ArrowRight') this.next()
    })
  }

  open(event) {
    const card = event.currentTarget
    this.currentIndex = parseInt(card.dataset.photoIndex, 10)
    this.showPhoto(this.currentIndex)
    this.lightboxTarget.classList.add('active')
    document.body.style.overflow = 'hidden'
  }

  close() {
    this.lightboxTarget.classList.remove('active')
    document.body.style.overflow = ''
  }

  prev() {
    if (this.currentIndex > 0) {
      this.currentIndex--
      this.showPhoto(this.currentIndex)
    }
  }

  next() {
    if (this.currentIndex < this.photos.length - 1) {
      this.currentIndex++
      this.showPhoto(this.currentIndex)
    }
  }

  showPhoto(index) {
    const img = this.lightboxTarget.querySelector('img')
    img.src = this.photos[index] || ''
    img.alt = `Photo ${index + 1}`
  }
}
