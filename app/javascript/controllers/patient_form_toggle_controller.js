import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  selectType(event) {
    const selectedType = event.target.value
    const url = new URL(window.location.href)
    url.searchParams.set('type', selectedType)
    window.location.href = url.toString()
  }
}
