import { Controller } from "@hotwired/stimulus"

const DEFAULT_FONTS = [
  { id: "dejavu_sans", name: "DejaVu Sans", preview: "AaBbCc 123" },
  { id: "dejavu_serif", name: "DejaVu Serif", preview: "AaBbCc 123" },
  { id: "dejavu_mono", name: "DejaVu Mono", preview: "AaBbCc 123" },
  { id: "lato", name: "Lato", preview: "AaBbCc 123" },
  { id: "lato_black", name: "Lato Black", preview: "AaBbCc 123" }
]

export default class extends Controller {
  static targets = ["grid", "hidden"]

  async connect() {
    this.customFonts = []
    await this.loadCustomFonts()
    this.renderFonts()
  }

  async loadCustomFonts() {
    try {
      const url = this.element.dataset.fontPickerUrl || "/fonts.json"
      const response = await fetch(url)
      if (response.ok) {
        const data = await response.json()
        this.customFonts = Array.isArray(data) ? data : data.fonts || []
      }
    } catch (e) {
      // Use only default fonts if fetch fails
    }
  }

  renderFonts() {
    const selectedId = this.element.dataset.fontPickerSelectedId || this.hiddenTarget?.value || ""

    let html = '<div class="font-picker-grid">'
    
    // Default option
    const isNoneSelected = selectedId === '' || selectedId === null || selectedId === undefined
    html += `<div class="font-picker-item${isNoneSelected ? ' selected' : ''}" 
                 data-id="">
      <span class="font-preview font-default">AaBbCc 123</span>
      <span class="font-name">Padrão</span>
    </div>`
    
    // Custom fonts from database
    for (const font of this.customFonts) {
      const isSelected = font.id == selectedId || font.name?.toLowerCase().replace(/\s+/g, '_') == selectedId
      html += `<div class="font-picker-item${isSelected ? ' selected' : ''}" 
                   data-id="${font.id}" 
                   data-font-name="${font.id}">
        <span class="font-preview">AaBbCc 123</span>
        <span class="font-name">${font.name}</span>
      </div>`
    }
    
    // Default system fonts
    for (const font of DEFAULT_FONTS) {
      const isSelected = font.id == selectedId
      html += `<div class="font-picker-item${isSelected ? ' selected' : ''}" 
                   data-id="${font.id}" 
                   data-font-family="${font.id}">
        <span class="font-preview" style="font-family: '${font.id}', sans-serif">${font.preview}</span>
        <span class="font-name">${font.name}</span>
      </div>`
    }
    
    html += '</div>'
    this.gridTarget.innerHTML = html

    this.gridTarget.querySelectorAll('.font-picker-item').forEach(item => {
      item.addEventListener('click', () => {
        this.selectFont(item, item.dataset.id)
      })
    })
  }

  selectFont(element, id) {
    this.gridTarget.querySelectorAll('.font-picker-item').forEach(item => {
      item.classList.remove('selected')
    })
    element.classList.add('selected')
    
    if (this.hiddenTarget) {
      this.hiddenTarget.value = id
    }
    
    this.dispatch('font:selected', { detail: { id } })
  }
}