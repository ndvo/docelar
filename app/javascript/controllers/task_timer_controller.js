import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "startBtn", "pauseBtn", "completeBtn"]
  static values = {
    taskId: { type: String, default: "" },
    startTime: { type: Number, default: 0 },
    elapsed: { type: Number, default: 0 }
  }

  connect() {
    this.interval = null
    this.loadState()
    if (this.startTimeValue > 0) {
      this.startTimer()
    }
    this.updateDisplay()
  }

  disconnect() {
    this.stopTimer()
  }

  loadState() {
    const state = sessionStorage.getItem(`task_timer_${this.taskIdValue}`)
    if (state) {
      const data = JSON.parse(state)
      this.startTimeValue = data.startTime || 0
      this.elapsedValue = data.elapsed || 0
    }
  }

  saveState() {
    const state = {
      startTime: this.startTimeValue,
      elapsed: this.elapsedValue
    }
    sessionStorage.setItem(`task_timer_${this.taskIdValue}`, JSON.stringify(state))
  }

  start(event) {
    event?.preventDefault()
    this.startTimeValue = Math.floor(Date.now() / 1000)
    this.startTimer()
    this.saveState()
    this.toggleButtons("running")
    this.sendAction("start")
  }

  pause(event) {
    event?.preventDefault()
    this.stopTimer()
    this.elapsedValue += Math.floor(Date.now() / 1000) - this.startTimeValue
    this.startTimeValue = 0
    this.saveState()
    this.toggleButtons("paused")
    this.sendAction("pause")
  }

  complete(event) {
    event?.preventDefault()
    this.stopTimer()
    if (this.startTimeValue > 0) {
      this.elapsedValue += Math.floor(Date.now() / 1000) - this.startTimeValue
    }
    this.startTimeValue = 0
    this.saveState()
    this.sendAction("complete")
  }

  startTimer() {
    this.stopTimer()
    this.interval = setInterval(() => {
      this.updateDisplay()
    }, 1000)
  }

  stopTimer() {
    if (this.interval) {
      clearInterval(this.interval)
      this.interval = null
    }
  }

  updateDisplay() {
    const totalSeconds = this.calculateTotalSeconds()
    const hours = Math.floor(totalSeconds / 3600)
    const minutes = Math.floor((totalSeconds % 3600) / 60)
    const seconds = totalSeconds % 60

    if (this.hasDisplayTarget) {
      if (hours > 0) {
        this.displayTarget.textContent = `${hours}:${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`
      } else {
        this.displayTarget.textContent = `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`
      }
    }
  }

  calculateTotalSeconds() {
    let total = this.elapsedValue || 0
    if (this.startTimeValue > 0) {
      total += Math.floor(Date.now() / 1000) - this.startTimeValue
    }
    return total
  }

  toggleButtons(state) {
    if (this.hasStartBtnTarget) {
      this.startBtnTarget.style.display = state === "paused" ? "inline-block" : "none"
    }
    if (this.hasPauseBtnTarget) {
      this.pauseBtnTarget.style.display = state === "running" ? "inline-block" : "none"
    }
    if (this.hasCompleteBtnTarget) {
      this.completeBtnTarget.style.display = "inline-block"
    }
  }

  sendAction(action) {
    const formData = new FormData()
    formData.append("task_id", this.taskIdValue)

    fetch(`/task_sessions/${action}`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": this.getMetaValue("csrf-token")
      },
      body: formData
    })
    .then(response => {
      if (response.ok) {
        // Optionally reload or update UI
        Turbo.visit(window.location.href, { action: "replace" })
      }
    })
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element ? element.content : ""
  }
}
