import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener('keydown', this.handleKeydown.bind(this))
  }

  handleKeydown(event) {
    const buttons = Array.from(this.element.querySelectorAll('[role="tab"]'))
    const currentIndex = buttons.indexOf(document.activeElement)
    
    switch(event.key) {
      case 'ArrowRight':
      case 'ArrowLeft':
        event.preventDefault()
        const direction = event.key === 'ArrowRight' ? 1 : -1
        const nextIndex = (currentIndex + direction + buttons.length) % buttons.length
        buttons[nextIndex].focus()
        buttons[nextIndex].click()
        break
      case 'Home':
        event.preventDefault()
        buttons[0].focus()
        break
      case 'End':
        event.preventDefault()
        buttons[buttons.length - 1].focus()
        break
    }
  }

  toggle(event) {
    const selected = event.target
    const type = selected.dataset.type
    
    this.element.querySelectorAll('[role="tab"]').forEach(btn => {
      btn.classList.remove('active')
      btn.setAttribute('aria-selected', 'false')
      btn.setAttribute('tabindex', '-1')
    })
    selected.classList.add('active')
    selected.setAttribute('aria-selected', 'true')
    selected.setAttribute('tabindex', '0')
    
    const currentPath = window.location.pathname
    const newPath = currentPath.includes('?') 
      ? currentPath.replace(/type=[^&]*/, `type=${type}`)
      : `${currentPath}?type=${type}`
    window.location.href = newPath
  }
}
