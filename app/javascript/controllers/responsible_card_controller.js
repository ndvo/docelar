import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "summary"]

  connect() {
    this.formTarget.addEventListener("submit", (event) => {
      event.preventDefault()
      this.submitForm(event)
    })

    this.summaryTarget?.addEventListener("click", () => {
      this.redirectToTasks()
    })
  }

  submitForm(event) {
    const form = event.target
    const frame = document.querySelector(`#${form.dataset.turboFrame}`)

    if (frame) frame.load(form.action)
  }

  redirectToTasks() {
    const link = this.summaryTarget.querySelector('a')
    if (link) Turbo.visit(link.href)
  }
}
