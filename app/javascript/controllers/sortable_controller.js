import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "item"]
  static values = { url: { type: String, default: "" } }

  connect() {
    this.setupDragAndDrop()
  }

  setupDragAndDrop() {
    const list = this.listTarget
    let draggedItem = null

    list.addEventListener("dragstart", (e) => {
      const item = e.target.closest("[data-sortable-id]")
      if (!item) return

      draggedItem = item
      item.classList.add("dragging")
      e.dataTransfer.effectAllowed = "move"
      e.dataTransfer.setData("text/plain", item.dataset.sortableId)
    })

    list.addEventListener("dragend", (e) => {
      const item = e.target.closest("[data-sortable-id]")
      if (item) {
        item.classList.remove("dragging")
      }
      draggedItem = null
    })

    list.addEventListener("dragover", (e) => {
      e.preventDefault()
      e.dataTransfer.dropEffect = "move"

      const afterElement = this.getDragAfterElement(list, e.clientY)
      const draggable = document.querySelector(".dragging")

      if (afterElement == null) {
        list.appendChild(draggable)
      } else {
        list.insertBefore(draggable, afterElement)
      }
    })

    list.addEventListener("drop", (e) => {
      e.preventDefault()
      this.updatePositions()
    })
  }

  getDragAfterElement(container, y) {
    const draggableElements = [...container.querySelectorAll("[data-sortable-id]:not(.dragging)")]

    return draggableElements.reduce(
      (closest, child) => {
        const box = child.getBoundingClientRect()
        const offset = y - box.top - box.height / 2

        if (offset < 0 && offset > closest.offset) {
          return { offset: offset, element: child }
        } else {
          return closest
        }
      },
      { offset: Number.NEGATIVE_INFINITY }
    ).element
  }

  updatePositions() {
    const items = this.listTarget.querySelectorAll("[data-sortable-id]")
    const updates = []

    items.forEach((item, index) => {
      updates.push({
        id: item.dataset.sortableId,
        position: index + 1
      })
    })

    // Send updates to server
    updates.forEach((update) => {
      fetch(`/task_log_entries/${update.id}/update_position`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.getMetaValue("csrf-token"),
          "Accept": "text/vnd.turbo-stream.html"
        },
        body: JSON.stringify({ position: update.position })
      })
    })
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element ? element.content : ""
  }
}
