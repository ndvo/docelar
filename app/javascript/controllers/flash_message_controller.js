import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    autodismiss: { type: Number, default: 5000 }
  }

  connect() {
    if (this.hasAutodismissValue && this.autodismissValue > 0) {
      this.timer = setTimeout(() => {
        this.dismiss()
      }, this.autodismissValue)
    }
  }

  disconnect() {
    if (this.timer) {
      clearTimeout(this.timer)
    }
  }

  dismiss() {
    this.element.classList.add('fade-out')
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}