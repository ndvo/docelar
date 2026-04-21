import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["video", "overlay", "selection"]

  connect() {
    try {
      console.log("VC: connect")
      this.isDragging = false
      
      if (this.hasOverlayTarget) {
        console.log("VC: overlay found")
        this.overlayTarget.addEventListener('mousedown', (e) => this.startDrag(e))
        this.overlayTarget.addEventListener('mousemove', (e) => this.doDrag(e))
        this.overlayTarget.addEventListener('mouseup', () => this.endDrag())
        this.overlayTarget.addEventListener('mouseleave', () => this.endDrag())
      }
      
      const clearBtn = document.getElementById('crop-clear')
      if (clearBtn) clearBtn.addEventListener('click', () => this.clearCrop())
    } catch (e) {
      console.error("VC: error", e)
    }
  }

  startDrag(e) {
    const rect = this.overlayTarget.getBoundingClientRect()
    this.videoWidth = rect.width
    this.videoHeight = rect.height
    
    this.isDragging = true
    this.element.classList.add('dragging')
    this.startX = e.clientX - rect.left
    this.startY = e.clientY - rect.top
    
    if (this.hasSelectionTarget) {
      this.selectionTarget.style.left = this.startX + 'px'
      this.selectionTarget.style.top = this.startY + 'px'
      this.selectionTarget.style.width = '0px'
      this.selectionTarget.style.height = '0px'
      this.selectionTarget.style.display = 'block'
    }
  }

  doDrag(e) {
    if (!this.isDragging) return
    
    const rect = this.overlayTarget.getBoundingClientRect()
    let currentX = e.clientX - rect.left
    let currentY = e.clientY - rect.top
    
    currentX = Math.max(0, Math.min(currentX, rect.width))
    currentY = Math.max(0, Math.min(currentY, rect.height))
    
    const x = Math.min(this.startX, currentX)
    const y = Math.min(this.startY, currentY)
    const w = Math.abs(currentX - this.startX)
    const h = Math.abs(currentY - this.startY)
    
    if (this.hasSelectionTarget) {
      this.selectionTarget.style.left = x + 'px'
      this.selectionTarget.style.top = y + 'px'
      this.selectionTarget.style.width = w + 'px'
      this.selectionTarget.style.height = h + 'px'
    }
  }

  endDrag() {
    if (!this.isDragging) return
    this.isDragging = false
    this.element.classList.remove('dragging')
    
    if (!this.hasSelectionTarget) return
    
    const rect = this.overlayTarget.getBoundingClientRect()
    
    const x = Math.round(parseFloat(this.selectionTarget.style.left))
    const y = Math.round(parseFloat(this.selectionTarget.style.top))
    const w = Math.round(parseFloat(this.selectionTarget.style.width))
    const h = Math.round(parseFloat(this.selectionTarget.style.height))
    
    if (w < 10 || h < 10) {
      this.clearCrop()
      return
    }
    
    console.log("Crop selected (display):", x, y, w, h)
    this.updateCropFields(x, y, w, h)
  }

  updateCropFields(x, y, w, h) {
    document.getElementById('crop_x').value = x
    document.getElementById('crop_y').value = y
    document.getElementById('crop_width').value = w
    document.getElementById('crop_height').value = h
    
    if (document.getElementById('crop_x_disp')) {
      document.getElementById('crop_x_disp').value = x
      document.getElementById('crop_y_disp').value = y
      document.getElementById('crop_w_disp').value = w
      document.getElementById('crop_h_disp').value = h
    }
  }

  clearCrop() {
    this.updateCropFields(0, 0, '', '')
    if (this.hasSelectionTarget) {
      this.selectionTarget.style.display = 'none'
    }
  }
}