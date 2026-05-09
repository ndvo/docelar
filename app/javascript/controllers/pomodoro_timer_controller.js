import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display", "progressCircle", "progressText", "startBtn", "pauseBtn", "resumeBtn", "completeBtn", "cancelBtn", "interruptionBtn", "taskName", "projectName"]
  static values = {
    sessionId: { type: String, default: "" },
    duration: { type: Number, default: 1500 }, // 25 minutes in seconds
    startTime: { type: Number, default: 0 },
    elapsed: { type: Number, default: 0 },
    status: { type: String, default: "planned" }
  }

  connect() {
    this.interval = null
    this.loadState()
    this.updateDisplay()
    this.updateProgress()
    this.updateButtons()

    if (this.statusValue === "in_progress" && this.startTimeValue > 0) {
      this.startTimer()
    }
  }

  disconnect() {
    this.stopTimer()
  }

  loadState() {
    if (!this.sessionIdValue) return
    const state = sessionStorage.getItem(`pomodoro_timer_${this.sessionIdValue}`)
    if (state) {
      const data = JSON.parse(state)
      this.startTimeValue = data.startTime || 0
      this.elapsedValue = data.elapsed || 0
      this.statusValue = data.status || "planned"
    }
  }

  saveState() {
    if (!this.sessionIdValue) return
    const state = {
      startTime: this.startTimeValue,
      elapsed: this.elapsedValue,
      status: this.statusValue
    }
    sessionStorage.setItem(`pomodoro_timer_${this.sessionIdValue}`, JSON.stringify(state))
  }

  start(event) {
    event?.preventDefault()
    this.startTimeValue = Math.floor(Date.now() / 1000)
    this.statusValue = "in_progress"
    this.startTimer()
    this.saveState()
    this.updateButtons()
    this.sendAction("start")
  }

  pause(event) {
    event?.preventDefault()
    this.stopTimer()
    this.elapsedValue += Math.floor(Date.now() / 1000) - this.startTimeValue
    this.startTimeValue = 0
    this.statusValue = "cancelled"
    this.saveState()
    this.updateButtons()
    this.sendAction("pause")
  }

  resume(event) {
    event?.preventDefault()
    this.startTimeValue = Math.floor(Date.now() / 1000)
    this.statusValue = "in_progress"
    this.startTimer()
    this.saveState()
    this.updateButtons()
    this.sendAction("resume")
  }

  complete(event) {
    event?.preventDefault()
    this.stopTimer()
    if (this.startTimeValue > 0) {
      this.elapsedValue += Math.floor(Date.now() / 1000) - this.startTimeValue
    }
    this.startTimeValue = 0
    this.statusValue = "completed"
    this.saveState()
    this.updateDisplay()
    this.updateProgress()
    this.updateButtons()
    this.sendAction("complete")
  }

  cancel(event) {
    event?.preventDefault()
    if (confirm("Are you sure you want to cancel this pomodoro?")) {
      this.stopTimer()
      this.sendAction("destroy")
    }
  }

  logInterruption(event) {
    event?.preventDefault()
    this.sendAction("log_interruption")
  }

  startTimer() {
    this.stopTimer()
    this.interval = setInterval(() => {
      this.updateDisplay()
      this.updateProgress()

      // Check if timer is complete
      if (this.calculateTotalSeconds() >= this.durationValue) {
        this.complete()
        this.playNotificationSound()
      }
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
    const remainingSeconds = Math.max(0, this.durationValue - totalSeconds)
    const minutes = Math.floor(remainingSeconds / 60)
    const seconds = remainingSeconds % 60

    if (this.hasDisplayTarget) {
      this.displayTarget.textContent = `${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}`
    }

    // Update page title
    document.title = `(${String(minutes).padStart(2, "0")}:${String(seconds).padStart(2, "0")}) Pomodoro Timer`
  }

  updateProgress() {
    if (!this.hasProgressCircleTarget) return

    const totalSeconds = this.calculateTotalSeconds()
    const progress = Math.min(totalSeconds / this.durationValue, 1)
    const circumference = 2 * Math.PI * 90 // radius = 90

    this.progressCircleTarget.style.strokeDasharray = `${circumference} ${circumference}`
    this.progressCircleTarget.style.strokeDashoffset = circumference * (1 - progress)

    if (this.hasProgressTextTarget) {
      const minutes = Math.floor(this.durationValue / 60)
      this.progressTextTarget.textContent = `${minutes} min`
    }
  }

  updateButtons() {
    const isRunning = this.statusValue === "in_progress" && this.startTimeValue > 0
    const isCompleted = this.statusValue === "completed"

    if (this.hasStartBtnTarget) {
      this.startBtnTarget.style.display = !isRunning && !isCompleted ? "inline-block" : "none"
    }
    if (this.hasPauseBtnTarget) {
      this.pauseBtnTarget.style.display = isRunning ? "inline-block" : "none"
    }
    if (this.hasResumeBtnTarget) {
      this.resumeBtnTarget.style.display = (this.statusValue === "cancelled" || this.statusValue === "paused") && !isCompleted ? "inline-block" : "none"
    }
    if (this.hasCompleteBtnTarget) {
      this.completeBtnTarget.style.display = !isCompleted ? "inline-block" : "none"
    }
    if (this.hasCancelBtnTarget) {
      this.cancelBtnTarget.style.display = !isCompleted ? "inline-block" : "none"
    }
    if (this.hasInterruptionBtnTarget) {
      this.interruptionBtnTarget.style.display = isRunning ? "inline-block" : "none"
    }
  }

  calculateTotalSeconds() {
    let total = this.elapsedValue || 0
    if (this.startTimeValue > 0) {
      total += Math.floor(Date.now() / 1000) - this.startTimeValue
    }
    return total
  }

  sendAction(action) {
    if (!this.sessionIdValue && action !== "start") return

    const url = this.sessionIdValue
      ? `/pomodoro_sessions/${this.sessionIdValue}/${action}`
      : `/pomodoro_sessions/${action}`

    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": this.getMetaValue("csrf-token"),
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    .then(response => {
      if (response.ok) {
        if (action === "complete" || action === "destroy") {
          Turbo.visit("/pomodoro_sessions", { action: "replace" })
        } else {
          Turbo.visit(window.location.href, { action: "replace" })
        }
      }
    })
  }

  playNotificationSound() {
    try {
      const audioContext = new (window.AudioContext || window.webkitAudioContext)()
      const oscillator = audioContext.createOscillator()
      const gainNode = audioContext.createGain()

      oscillator.connect(gainNode)
      gainNode.connect(audioContext.destination)

      oscillator.frequency.value = 800
      oscillator.type = "sine"

      gainNode.gain.setValueAtTime(0.5, audioContext.currentTime)
      gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 1)

      oscillator.start(audioContext.currentTime)
      oscillator.stop(audioContext.currentTime + 1)
    } catch (e) {
      console.warn("Web Audio API not supported:", e)
    }
  }

  getMetaValue(name) {
    const element = document.head.querySelector(`meta[name="${name}"]`)
    return element ? element.content : ""
  }
}
