import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "progress"]

  initialize() {
    this.updateProgress = this.updateProgress.bind(this)
  }

  connect() {
    this.checkboxes = this.element.querySelectorAll('input[type="checkbox"][data-action="checklist#toggle"]')
    this.checkboxes.forEach(cb => {
      cb.addEventListener('change', this.updateProgress)
    })
  }

  disconnect() {
    this.checkboxes.forEach(cb => {
      cb.removeEventListener('change', this.updateProgress)
    })
  }

  toggle(event) {
    const checkbox = event.target
    const index = checkbox.dataset.index
    if (checkbox.checked) {
      checkbox.nextElementSibling.classList.add('checked')
    } else {
      checkbox.nextElementSibling.classList.remove('checked')
    }
    this.updateProgress()
  }

  updateProgress() {
    const total = this.checkboxes.length
    if (total === 0) return
    
    const checked = Array.from(this.checkboxes).filter(cb => cb.checked).length
    const progress = Math.round((checked / total) * 100)
    
    const progressBar = this.element.querySelector('.progress-bar')
    if (progressBar) {
      progressBar.style.width = `${progress}%`
      const progressText = progressBar.querySelector('.progress-text')
      if (progressText) {
        progressText.textContent = `${progress}% completo`
      }
    }
  }
}
